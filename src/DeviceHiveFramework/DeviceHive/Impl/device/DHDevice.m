//
//  DHDevice.m
//  DeviceHiveFramework
//
//  Created by Maxim Kiselev on 10/27/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHDevice.h"
#import "DHLog.h"
#import "DHDeviceClass.h"
#import "DHNetwork.h"
#import "DHEquipment.h"
#import "DHCommandResult.h"
#import "DHNotification.h"
#import "DHEquipment.h"
#import "DHEquipment+Private.h"
#import "DHDeviceService.h"
#import "DHDeviceData.h"
#import "DHCommandQueue.h"
#import "NSError+PrivateAdditions.h"
#import "DHApiInfo.h"

NSString* const kDeviceEquipmentParameter = @"equipment";

typedef void (^DHCommandPollCompletionBlock)(BOOL success);

@interface DHDevice ()

@property (nonatomic, strong, readwrite) DHDeviceData* deviceData;
@property (nonatomic, strong, readwrite) id<DHDeviceService> deviceService;
@property (nonatomic, readwrite) BOOL isRegistered;

@property (nonatomic, readwrite) BOOL isProcessingCommands;
@property (nonatomic, strong) DHCommandQueue* commandQueue;
@property (nonatomic) BOOL isCommandPollRequestInProgress;

@end

@implementation DHDevice


- (id)initWithDeviceData:(DHDeviceData*)deviceData {
    
    self = [super init];
    if (self) {
        _deviceData = deviceData;
        _isRegistered = NO;
        _isProcessingCommands = NO;
        _isCommandPollRequestInProgress = NO;
        _commandQueue = [[DHCommandQueue alloc] init];
        [self attachEquipments:_deviceData.equipment];
    }
    return self;
}

- (void)registerDeviceWithDeviceService:(id<DHDeviceService>)deviceService
                                success:(DHDeviceSuccessCompletionBlock)success
                                failure:(DHDeviceFailureCompletionBlock)failure {
    if (self.isRegistered) {
        [self unregisterDevice];
    }
    self.deviceService = deviceService;
    [self willStartRegistration];
    DHLog(@"Registering device: %@", [self.deviceData description]);
    [self.deviceService registerDevice:self.deviceData success:^(DHDeviceData* deviceData) {
        DHLog(@"Registration request finished:%@", [deviceData description]);
        DHLog(@"Sending device status notification");
        [self sendNotification:[DHDeviceStatusNotification onlineStatusNotification]
                       success:^(DHNotification* notification) {
                           DHLog(@"Device status notification posted: %@", [notification description]);
                           DHLog(@"Registering equipment...");
                           BOOL registered = [self registerEquipment];
                           if (registered) {
                               DHLog(@"Equipment registered");
                               self.isRegistered = YES;
                               [self didFinishRegistration];
                               success(deviceData);
                           } else {
                               DHLog(@"Failed to register equipment");
                               failure([NSError equipmentErrorWithUserInfo:@{ NSLocalizedDescriptionKey : @"Failed to register equipment" }]);
                           }
                       } failure:^(NSError *error) {
                           DHLog(@"Registration request failed with error:%@", error);
                           [self didFailRegistrationWithError:error];
                           failure(error);
                       }];
    } failure:^(NSError *error) {
        DHLog(@"Registration request failed with error:%@", error);
        [self didFailRegistrationWithError:error];
        failure(error);
    }];
}

- (void)unregisterDevice {
    if (self.isRegistered) {
        [self willUnregister];
        if (self.isProcessingCommands) {
            [self stopProcessingCommands];
            [self.deviceService cancelAllServiceRequests];
        }
        self.isRegistered = NO;
        self.commandQueue = [[DHCommandQueue alloc] init];
        self.isCommandPollRequestInProgress = NO;
        [self unregisterEquipment];
        [self didUnregister];
    }
}

- (void)sendNotification:(DHNotification*)notification
                 success:(DHDeviceSuccessCompletionBlock)success
                 failure:(DHDeviceFailureCompletionBlock)failure {
    [self willSendNotification:notification];
    [self.deviceService sendNotification:notification
                               forDevice:self.deviceData
                                 success:^(id response) {
                                     [self didSendNotification:notification];
                                     success(response);
                                 } failure:^(NSError *error) {
                                     [self didFailSendNotification:notification
                                                         withError:error];
                                     failure(error);
                                 }];
}

- (void)reloadDeviceDataWithSuccess:(DHDeviceSuccessCompletionBlock)success
                            failure:(DHDeviceFailureCompletionBlock)failure {
    [self.deviceService getDeviceData:self.deviceData
                           completion:^(DHDeviceData* deviceData) {
                               [self updateDeviceData:deviceData];
                               success(deviceData);
                           } failure:^(NSError *error) {
                               failure(error);
                           }];
}

- (void)updateDeviceData:(DHDeviceData *)deviceData {
    self.deviceData = [[DHDeviceData alloc] initWithID:self.deviceData.deviceID
                                                   key:self.deviceData.key
                                                  name:deviceData.name
                                                status:deviceData.status
                                               network:deviceData.network
                                           deviceClass:deviceData.deviceClass
                                             equipment:self.deviceData.equipment];
}

- (void)beginProcessingCommands {
    if (!self.isRegistered) {
        NSLog(@"Device should be registered in order to be able to execute commands");
    } else {
        if (self.isProcessingCommands) {
            [self stopProcessingCommands];
        }
        [self willBeginProcessingCommandsInternal];
        self.isProcessingCommands = YES;
        [self executeNextCommand];
    }
}

- (void)stopProcessingCommands {
    if (!self.isRegistered) {
        NSLog(@"Device should be registered in order to be able to execute commands");
    } else {
        self.isProcessingCommands = NO;
        [self didStopProcessingCommandsInternal];
    }
}

- (void)executeNextCommand {
    if (self.isProcessingCommands) {
        if (!self.isCommandPollRequestInProgress) {
            DHCommand* command = [self.commandQueue dequeueObject];
            if (command) {
                [self doExecuteCommand:command completion:^(DHCommandResult *result) {
                    [self executeNextCommand];
                }];
            } else {
                [self pollNextCommandWithCompletion:^(BOOL success) {
                    [self executeNextCommand];
                }];
            }
        }
    }
}

- (void)pollNextCommandWithCompletion:(DHCommandPollCompletionBlock)completion {
    // we already have one poll request in progress just wait for it to finish
    if (!self.isCommandPollRequestInProgress) {
        self.isCommandPollRequestInProgress = YES;
        if (!self.lastCommandPollTimestamp) {
            // timestamp wasn't specified. Request and use server timestamp instead.
            [self.deviceService getApiInfoWithSuccess:^(DHApiInfo* apiInfo) {
                self.lastCommandPollTimestamp = apiInfo.serverTimestamp;
                [self doPollNextCommandWithCompletion:completion];
            } failure:^(NSError *error) {
                DHLog(@"Failed to get service info with error: %@", [error description]);
                self.isCommandPollRequestInProgress = NO;
                completion(NO);
            }];
        } else {
            [self doPollNextCommandWithCompletion:completion];
        }
    }
}

- (void)doPollNextCommandWithCompletion:(DHCommandPollCompletionBlock)completion {
    DHLog(@"Poll next command for device: %@ starting from date: (%@)",
          self.deviceData.name, self.lastCommandPollTimestamp);
    [self.deviceService pollCommandsForDevice:self.deviceData
                                        since:self.lastCommandPollTimestamp
                                  waitTimeout:self.commandPollWaitTimeout
                                   completion:^(NSArray* commands) {
                                       DHLog(@"Got commands: %@", [commands description]);
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
                                   }];
    
}


- (void)doExecuteCommand:(DHCommand *)command completion:(DHCommandCompletionBlock)completion {
    
    DHCommandCompletionBlock commandCompletion = ^(DHCommandResult* result) {
        [self.deviceService updateCommand:command
                                forDevice:self.deviceData
                               withResult:result
                                  success:^(id response) {
                                      completion(result);
                                  }
                                  failure:^(NSError *error) {
                                      DHLog(@"Failed to update command's(%@) status(%@): ", command.name, result);
                                      completion(result);
                                  }];
    };
    
    if ([self respondsToSelector:@selector(willExecuteCommand:)]) {
        [self willExecuteCommand:command];
    }
    BOOL parametersPresent = command.parameters && (id)command.parameters != (id)[NSNull null];
    BOOL isParametersDictionary = [command.parameters isKindOfClass:[NSDictionary class]];
    if (!parametersPresent || !isParametersDictionary || !command.parameters[kDeviceEquipmentParameter]) {
        [self executeCommand:command onExecutor:self completion:commandCompletion];
    } else {
        DHEquipment* equipment = [self equipmentWithCode:command.parameters[kDeviceEquipmentParameter]];
        if (equipment) {
            if ([equipment respondsToSelector:@selector(willExecuteCommand:)]) {
                [equipment willExecuteCommand:command];
            }
            [self executeCommand:command onExecutor:equipment completion:commandCompletion];
        } else {
            commandCompletion([DHCommandResult commandResultWithStatus:DHCommandStatusFailed
                                                                result:@"Equipment not found"]);
        }
    }
}

- (void)executeCommand:(DHCommand*)command
            onExecutor:(id<DHCommandExecutor>)executor
            completion:(DHCommandCompletionBlock)completion {
    
    [executor executeCommand:command
                  completion:completion];
}


- (void)attachEquipments:(NSArray*)equipments {
    for (DHEquipment* equipment in equipments) {
        equipment.device = self;
    }
}

- (void)willBeginProcessingCommandsInternal {
    [self willBeginProcessingCommands];
    for (DHEquipment* equipment in self.deviceData.equipment) {
        [equipment deviceWillBeginProcessingCommands:self];
    }
}

- (void)didStopProcessingCommandsInternal {
    for (DHEquipment* equipment in self.deviceData.equipment) {
        [equipment deviceDidStopProcessingCommands:self];
    }
    [self didStopProcessingCommands];
}

- (BOOL)registerEquipment {
    BOOL result = YES;
    for (DHEquipment* equipment in self.deviceData.equipment) {
        result = result && [equipment registerEquipmentWithDevice:self];
    }
    return result;
}

- (BOOL)unregisterEquipment {
    BOOL result = YES;
    for (DHEquipment* equipment in self.deviceData.equipment) {
        result = result && [equipment unregisterEquipmentWithDevice:self];
    }
    return result;
}

- (DHEquipment*)equipmentWithCode:(NSString*)code {
    for (DHEquipment* equipment in self.deviceData.equipment) {
        if ([equipment.code isEqualToString:code]) {
            return equipment;
        }
    }
    return nil;
}

- (void)willStartRegistration {
    
}

- (void)didFinishRegistration {
    
}

- (void)didFailRegistrationWithError:(NSError *)error {
    
}

- (void)willBeginProcessingCommands {
    
}

- (void)didStopProcessingCommands {
    
}

- (void)willSendNotification:(DHNotification*)notification {
    
}

- (void)didSendNotification:(DHNotification*)notification {
    
}

- (void)didFailSendNotification:(DHNotification*)notification
                      withError:(NSError*)error {
    
}

- (void)willUnregister {
    
}

- (void)didUnregister {
    
}

- (BOOL)shouldExecuteCommand:(DHCommand*)command {
    DHLog(@"Abstract device received the command: %@. Descendants should override this method in order to be able to execute commands", command.name);
    return NO;
}

- (void)executeCommand:(DHCommand*)command
            completion:(DHCommandCompletionBlock)completion {
    DHLog(@"Abstract device received the command: %@. Descendants should override this method in order to be able to execute commands", command.name);
    completion([DHCommandResult commandResultWithStatus:DHCommandStatusFailed result:nil]);
}

@end
