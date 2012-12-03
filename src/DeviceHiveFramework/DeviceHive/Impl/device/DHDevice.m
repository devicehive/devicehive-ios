//
//  DHDevice.m
//  DeviceHiveDevice
//
//  Created by Alex Maydanik on 10/27/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
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

@interface DHDevice ()

@property (nonatomic, strong, readwrite) id<DHDeviceService> deviceService;
@property (nonatomic, readwrite) BOOL isRegistered;

@end

@implementation DHDevice


- (id)initWithDeviceData:(DHDeviceData*)deviceData
           deviceService:(id<DHDeviceService>)deviceService {
    
    self = [super init];
    if (self) {
        _deviceData = deviceData;
        _deviceService = deviceService;
        _isRegistered = NO;
        [self attachEquipments:_deviceData.equipment];
    }
    return self;
}

- (void)registerDeviceWithSuccess:(DHDeviceSuccessCompletionBlock)success
                          failure:(DHDeviceFailureCompletionBlock)failure {
    
    [self willStartRegistration];
    [self.deviceService registerDevice:self success:^(id response) {
        self.isRegistered = YES;
        [self didFinishRegistration];
        success(response);
    } failure:^(NSError *error) {
        [self didFailRegistrationWithError:error];
        failure(error);
    }];
}

- (void)sendNotification:(DHNotification*)notification
                 success:(DHDeviceSuccessCompletionBlock)success
                 failure:(DHDeviceFailureCompletionBlock)failure {
    [self willSendNotification:notification];
    [self.deviceService sendNotification:notification
                               forDevice:self
                                 success:^(id response) {
                                     [self didSendNotification:notification];
                                     success(response);
                                 } failure:^(NSError *error) {
                                     [self didFailSendNotification:notification
                                                         withError:error];
                                     failure(error);
                                 }];
}

- (void)beginProcessingCommands {
    if (!self.isRegistered) {
        NSLog(@"Device should be registered in order to be able to execute commands");
    } else {
        [self willBeginProcessingCommandsInternal];
        [self.deviceService beginProcessingCommandsForDevice:self];
    }
}

- (void)stopProcessingCommands {
    if (!self.isRegistered) {
        NSLog(@"Device should be registered in order to be able to execute commands");
    } else {
        [self.deviceService stopProcessingCommandsForDevice:self];
        [self didStopProcessingCommandsInternal];
    }
}

- (BOOL)isProcessingCommands {
    return self.deviceService.isProcessingCommands;
}

- (void)attachEquipments:(NSArray*)equipments {
    for (DHEquipment* equipment in equipments) {
        equipment.device = self;
    }
}

- (void)willBeginProcessingCommandsInternal {
    [self willBeginProcessingCommands];
    for (DHEquipment* equipment in self.deviceData.equipment) {
        [equipment deviceWillBeginProcessingCommands];
    }
}

- (void)didStopProcessingCommandsInternal {
    for (DHEquipment* equipment in self.deviceData.equipment) {
        [equipment deviceDidStopProcessingCommands];
    }
    [self didStopProcessingCommands];
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
