//
//  DHDeviceService.m
//  DeviceHiveDevice
//
//  Created by Maxim Kiselev on 11/07/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHRestfulDeviceService.h"
#import "DHDefaultRestfulApiClient.h"
#import "DHDevice.h"
#import "DHEquipment.h"
#import "DHEquipmentData.h"
#import "DHNotification.h"
#import "DHCommand.h"
#import "DHEntity+SerializationPrivate.h"
#import "DHCommandResult.h"
#import "DHDeviceStatusNotification.h"
#import "DHCommandQueue.h"
#import "DHDeviceData.h"
#import "DHCommand+Private.h"
#import "DHLog.h"

NSString* const kDeviceEquipmentParameter = @"equipment";

typedef void (^DHCommandPollCompletionBlock)(BOOL success);


NSString* encodeToPercentEscapeString(NSString *string) {
    return (__bridge_transfer NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (CFStringRef) string,
                                            NULL,
                                            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
}


@interface DHRestfulDeviceService ()

@property (nonatomic, strong) id<DHRestfulApiClient> restfulApiClient;
@property (nonatomic, readwrite) BOOL isProcessingCommands;
@property (nonatomic, strong) DHCommandQueue* commandQueue;
@property (nonatomic) BOOL isCommandPollRequestInProgress;

@end


@implementation DHRestfulDeviceService {
    NSString* _lastCommandPollTimestamp;
}

@synthesize lastCommandPollTimestamp = _lastCommandPollTimestamp;

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithApiClient:(id<DHRestfulApiClient>)restfulApiClient {
    self = [super init];
    if (self) {
        _restfulApiClient = restfulApiClient;
        _isProcessingCommands = NO;
        _isCommandPollRequestInProgress = NO;
        _commandQueue = [[DHCommandQueue alloc] init];
    }
    return self;
}

- (void)registerDevice:(DHDevice*)device
               success:(DHDeviceServiceSuccessCompletionBlock) success
               failure:(DHDeviceServiceFailureCompletionBlock) failure {
    
    NSString* path = [NSString stringWithFormat:@"device/%@", device.deviceData.deviceID];
    [self setupAuthenticationForDevice:device];
    DHLog(@"Registering device: %@", [[device.deviceData classDictionary] description]);
    [self.restfulApiClient put:path
                    parameters:[device.deviceData classDictionary]
                       success:^(id response) {
                           DHLog(@"Registration request finished:%@", [response description]);
                           DHLog(@"Sending device status notification");
                           [self sendNotification:[DHDeviceStatusNotification onlineStatusNotification]
                                        forDevice:device 
                                          success:^(id response) {
                                              DHLog(@"Device status notification posted: %@", [response description]);
                                              DHLog(@"Registering equipment...");
                                              [self registerEquipmentForDevice:device completion:^(BOOL registered) {
                                                  if (registered) {
                                                      DHLog(@"Equipment registered");
                                                      success([[DHDeviceData alloc] initWithDictionary:response]);
                                                  } else {
                                                      DHLog(@"Failed to register equipment");
                                                      // TODO: construct proper NSError
                                                      failure(nil);
                                                  }
                                              }];
                                          } failure:^(NSError *error) {
                                              DHLog(@"Registration request failed with error:%@", error);
                                              failure(error);
                                          }];
                       } failure:^(NSError *error) {
                           DHLog(@"Registration request failed with error:%@", error);
                           failure(error);
                       }
     ];
}

- (void)sendNotification:(DHNotification*)notification
               forDevice:(DHDevice*)device
                 success:(DHDeviceServiceSuccessCompletionBlock) success
                 failure:(DHDeviceServiceFailureCompletionBlock) failure {
    
    [self setupAuthenticationForDevice:device];
    NSString* path = [NSString stringWithFormat:@"device/%@/notification", device.deviceData.deviceID];
    [self.restfulApiClient post:path
                     parameters:[notification classDictionary]
                        success:^(id response) {
                            DHLog(@"Notification sent:%@", [response description]);
                            success(response);
                        } failure:^(NSError *error) {
                            DHLog(@"Sending notification failed with error:%@", error);
                            failure(error);
                        }];
    
}

- (void)updateCommand:(DHCommand*)command
            forDevice:(DHDevice*)device
           withResult:(DHCommandResult*)result
              success:(DHDeviceServiceSuccessCompletionBlock) success
              failure:(DHDeviceServiceFailureCompletionBlock) failure; {
    
    [self setupAuthenticationForDevice:device];
    
    NSString* path = [NSString stringWithFormat:@"device/%@/command/%@", device.deviceData.deviceID, command.commandID];
    [self.restfulApiClient put:path
                    parameters:[result classDictionary]
                       success:^(id response) {
                           DHLog(@"Command updating finished:%@", command.name);
                           success([[DHCommand alloc] initWithDictionary:response]);
                       } failure:^(NSError *error) {
                           DHLog(@"Command updating failed with error:%@", error);
                           failure(error);
                       }
     ];
}

- (void)beginProcessingCommandsForDevice:(DHDevice *)device {
    if (self.isProcessingCommands) {
        [self stopProcessingCommandsForDevice:device];
    }
    self.isProcessingCommands = YES;
    [self executeNextCommandForDevice:device];
}

- (void)stopProcessingCommandsForDevice:(DHDevice *)device {
     self.isProcessingCommands = NO;
}

- (void)executeNextCommandForDevice:(DHDevice*)device {
    if (self.isProcessingCommands) {
        if (!self.isCommandPollRequestInProgress) {
            DHCommand* command = [self.commandQueue dequeue];
            if (command) {
                [self executeCommand:command forDevice:device completion:^(DHCommandResult *result) {
                    if (self.isProcessingCommands) {
                        [self executeNextCommandForDevice:device];
                    }
                }];
            } else {
                [self pollNextCommandForDevice:device completion:^(BOOL success) {
                    [self executeNextCommandForDevice:device];
                }];
            }
        }
    }
}

- (void)pollNextCommandForDevice:(DHDevice*)device
                      completion:(DHCommandPollCompletionBlock)completion {
    // we already have one poll request in progress just wait for it to finish
    if (!self.isCommandPollRequestInProgress) {
        DHLog(@"Poll next command for device: %@ starting from date: (%@)",
              device.deviceData.name, self.lastCommandPollTimestamp);
        self.isCommandPollRequestInProgress = YES;
        NSString* path = [self commandPollRequestPathForDevice:device];
        [self.restfulApiClient get:path
                        parameters:nil
                           success:^(id response) {
                               DHLog(@"Got commands: %@", [response description]);
                               NSArray* commands = [DHCommand commandsFromArrayOfDictionaries:response];
                               if (commands.count > 0) {
                                   self.lastCommandPollTimestamp = [[commands lastObject] timeStamp];
                               }
                               NSUInteger enqueuedCommandCount = [self.commandQueue enqueueAllNotCompleted:commands];
                               DHLog(@"Enqueued commands count: %d", enqueuedCommandCount);
                               self.isCommandPollRequestInProgress = NO;
                               completion(YES);
                           } failure:^(NSError *error) {
                               DHLog(@"Failed to poll commands with error:%@", error);
                               self.isCommandPollRequestInProgress = NO;
                               completion(NO);
                           }
         ];
    }
}

- (NSString*)commandPollRequestPathForDevice:(DHDevice*)device {
    NSString* path = nil;
    if (self.lastCommandPollTimestamp) {
        path = [NSString stringWithFormat:@"device/%@/command/poll?timestamp=%@",
        //path = [NSString stringWithFormat:@"device/%@/command/poll?timestamp=%@",
                device.deviceData.deviceID, encodeToPercentEscapeString(self.lastCommandPollTimestamp)];
    } else {
        path = [NSString stringWithFormat:@"device/%@/command/poll", device.deviceData.deviceID];
    }
    return path;
}

- (void)executeCommand:(DHCommand*)command
             forDevice:(DHDevice*)device
            completion:(DHCommandCompletionBlock)completion {
    
    DHCommandCompletionBlock commandCompletion = ^(DHCommandResult* result) {
        [self updateCommand:command
                  forDevice:device
                 withResult:result
                    success:^(id response) {
                        completion(result);
                    }
                    failure:^(NSError *error) {
                        DHLog(@"Failed to update command's(%@) status(%@): ", command.name, result);
                        completion(result);
                    }];
    };
    
    BOOL parametersPresent = command.parameters && (id)command.parameters != (id)[NSNull null];
    if (!parametersPresent || !command.parameters[kDeviceEquipmentParameter]) {
        [self executeCommand:command onExecutor:device completion:^(DHCommandResult *result) {
            commandCompletion(result);
        }];
    } else {
        DHEquipment* equipment = [self equipmentOfDevice:device
                                                withCode:command.parameters[kDeviceEquipmentParameter]];
        if (equipment) {
            [self executeCommand:command onExecutor:equipment completion:^(DHCommandResult *result) {
                commandCompletion(result);
            }];
        } else {
            commandCompletion([DHCommandResult commandResultWithStatus:DHCommandStatusFailed
                                                                result:@"Equipment not found"]);
        }
    }
}

- (void)executeCommand:(DHCommand*)command
            onExecutor:(id<DHCommandExecutor>)executor
            completion:(DHCommandCompletionBlock)completion{
    if ([executor shouldExecuteCommand:command]) {
        [executor executeCommand:command completion:completion];
    } else {
        completion([DHCommandResult commandResultWithStatus:DHCommandStatusFailed
                                                     result:@"Device/Equipment rejected command"]);
    }
}

- (void)setupAuthenticationForDevice:(DHDevice*)device {
    [self.restfulApiClient setHeader:@"Auth-DeviceID"
                               value:device.deviceData.deviceID];
    [self.restfulApiClient setHeader:@"Auth-DeviceKey"
                               value:device.deviceData.key];
}

- (void)registerEquipmentForDevice:(DHDevice*)device
                        completion:(DHEquipmentOperationCompletionBlock)completion {
    NSMutableSet* processedEquipment = [NSMutableSet set];
    NSMutableSet* registeredEquipment = [NSMutableSet set];
    for (DHEquipment* equipment in device.deviceData.equipments) {
        [equipment registerEquipmentWithCompletion:^(BOOL success) {
            [processedEquipment addObject:equipment];
            if (success) {
                DHLog(@"Registered equipment: %@", equipment.equipmentData.name);
                [registeredEquipment addObject:equipment];
            } else {
                DHLog(@"Failed to register equipment: %@", equipment.equipmentData.name);
            }
            if (processedEquipment.count == device.deviceData.equipments.count) {
                completion([processedEquipment isEqualToSet:registeredEquipment]);
            }
        }];
    }
}

- (void)unregisterEquipmentForDevice:(DHDevice*)device
                          completion:(DHEquipmentOperationCompletionBlock)completion {
    NSMutableSet* processedEquipment = [NSMutableSet set];
    NSMutableSet* unregisteredEquipment = [NSMutableSet set];
    for (DHEquipment* equipment in device.deviceData.equipments) {
        [equipment unregisterEquipmentWithCompletion:^(BOOL success) {
            [processedEquipment addObject:equipment];
            if (success) {
                DHLog(@"Unregistered equipment: %@", equipment.equipmentData.name);
                [unregisteredEquipment addObject:equipment];
            } else {
                DHLog(@"Failed to unregister equipment: %@", equipment.equipmentData.name);
            }
            if (processedEquipment.count == device.deviceData.equipments.count) {
                completion([processedEquipment isEqualToSet:unregisteredEquipment]);
            }
            
        }];
    }
}

- (DHEquipment*)equipmentOfDevice:(DHDevice*)device withCode:(NSString*)code {
    for (DHEquipment* equipment in device.deviceData.equipments) {
        if ([equipment.equipmentData.code isEqualToString:code]) {
            return equipment;
        }
    }
    return nil;
}

@end
