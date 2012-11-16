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

typedef void (^DHCommandPollCompletionBlock)(DHCommand* command);


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
@property (nonatomic, readwrite) BOOL isExecutingCommands;
@property (nonatomic, strong) DHCommandQueue* commandQueue;
@property (nonatomic) NSTimeInterval lastCommandPollRequestTime;

@end


@implementation DHRestfulDeviceService {
    NSDate* _lastCommandPollTimestamp;
    NSTimeInterval _minimumCommandPollInterval;
}

@synthesize lastCommandPollTimestamp = _lastCommandPollTimestamp;
@synthesize minimumCommandPollInterval = _minimumCommandPollInterval;

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithApiClient:(id<DHRestfulApiClient>)restfulApiClient {
    self = [super init];
    if (self) {
        _restfulApiClient = restfulApiClient;
        _isExecutingCommands = NO;
        _commandQueue = [[DHCommandQueue alloc] init];
        _minimumCommandPollInterval = 3.0;
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
                           DHLog(@"Command updating finished:%@", [response description]);
                           success([[DHCommand alloc] initWithDictionary:response]);
                       } failure:^(NSError *error) {
                           DHLog(@"Command updating failed with error:%@", error);
                           failure(error);
                       }
     ];
}

- (void)beginExecutingCommandsForDevice:(DHDevice *)device {
    if (self.isExecutingCommands) {
        [self stopExecutingCommandsForDevice:device];
    }
    self.isExecutingCommands = YES;
    [self executeNextCommandForDevice:device];
}

- (void)stopExecutingCommandsForDevice:(DHDevice *)device {
     self.isExecutingCommands = NO;
}

- (void)executeNextCommandForDevice:(DHDevice*)device {
    if (self.isExecutingCommands) {
        [self nextCommandForDevice:device completion:^(DHCommand *command) {
            if (command) {
                [self executeCommand:command forDevice:device completion:^(DHCommandResult *result) {
                    if (self.isExecutingCommands) {
                        [self scheduleExecuteNextCommandForDevice:device];
                    }
                }];
            } else {
                if (self.isExecutingCommands) {
                    [self scheduleExecuteNextCommandForDevice:device];
                }
            }
        }];
    }
}

- (void)scheduleExecuteNextCommandForDevice:(DHDevice*)device {
    NSTimeInterval currentTime = CACurrentMediaTime();
    NSTimeInterval timeElapsedSinceLastPollRequest = currentTime - self.lastCommandPollRequestTime;
    if (timeElapsedSinceLastPollRequest > self.minimumCommandPollInterval) {
        [self executeNextCommandForDevice:device];
    } else {
        [self performSelector:@selector(executeNextCommandForDevice:)
                   withObject:device afterDelay:self.minimumCommandPollInterval - timeElapsedSinceLastPollRequest];
    }

}

- (void)nextCommandForDevice:(DHDevice*)device
                  completion:(DHCommandPollCompletionBlock)completion {
    DHLog(@"Poll next command for device: %@ starting from date: (%@)",
          device.deviceData.name, [[DHCommand defaultTimestampFormatter] stringFromDate:self.lastCommandPollTimestamp]);
    DHCommand* command = [self.commandQueue dequeue];
    if (command) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(command);
        });
    } else {
        NSString* path = [self commandPollRequestPathForDevice:device];
        self.lastCommandPollRequestTime = CACurrentMediaTime();
        [self.restfulApiClient get:path
                        parameters:nil
                           success:^(id response) {
                               DHLog(@"Got commands: %@", [response description]);
                               //self.lastPollTimestamp = [NSDate date];
                               NSArray* commands = [DHCommand commandsFromArrayOfDictionaries:response];
                               if (commands.count > 0) {
                                   self.lastCommandPollTimestamp = [[commands lastObject] timeStamp];
                               }
                               NSUInteger enqueuedCommandCount = [self.commandQueue enqueueAllNotCompleted:commands];
                               DHLog(@"Enqueued commands count: %d", enqueuedCommandCount);
                               completion([self.commandQueue dequeue]);
                           } failure:^(NSError *error) {
                               DHLog(@"Failed to poll commands with error:%@", error);
                               // there is no commands to return to the caller
                               completion(nil);
                           }
         ];
    }

}

- (NSString*)commandPollRequestPathForDevice:(DHDevice*)device {
    NSString* path = nil;
    if (self.lastCommandPollTimestamp) {
        NSDateFormatter* df = [DHCommand defaultTimestampFormatter];
        path = [NSString stringWithFormat:@"device/%@/command?start=%@",
        //path = [NSString stringWithFormat:@"device/%@/command/poll?timestamp=%@",
                device.deviceData.deviceID, encodeToPercentEscapeString([df stringFromDate:self.lastCommandPollTimestamp])];
    } else {
        path = [NSString stringWithFormat:@"device/%@/command", device.deviceData.deviceID];
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
