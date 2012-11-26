//
//  DHEquipment.m
//  DeviceHiveDevice
//
//  Created by Alex Maydanik on 10/27/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHEquipment.h"
#import "DHLog.h"
#import "DHCommandResult.h"
#import "DHCommand.h"
#import "DHEquipment+Private.h"
#import "DHEquipmentNotification.h"

@interface DHEquipment ()

@property (nonatomic, weak, readwrite) DHDevice* device;

@end

@implementation DHEquipment

- (id)initWithEquipmentData:(DHEquipmentData*)equipmentData {
    self = [super init];
    if (self) {
        _equipmentData = equipmentData;
    }
    return self;
}

- (void)sendNotification:(DHEquipmentNotification*)notification
                 success:(DHDeviceSuccessCompletionBlock)success
                 failure:(DHDeviceFailureCompletionBlock)failure {
    if (self.device) {
        [self.device sendNotification:notification
                              success:^(id response) {
                                  success(response);
                              } failure:^(NSError *error) {
                                  failure(error);
                              }];
    } else {
        DHLog(@"Equipment should be attached to a device in order to be able to send notifications");
        // TODO: construct NSError here
        failure(nil);
    }
}


- (void)registerEquipmentWithCompletion:(DHEquipmentOperationCompletionBlock)completion {
    completion(YES);
}

- (void)unregisterEquipmentWithCompletion:(DHEquipmentOperationCompletionBlock)completion {
    completion(YES);
}

- (void)deviceWillBeginProcessingCommands {
    
}

- (void)deviceDidStopProcessingCommands {
    
}

- (BOOL)shouldExecuteCommand:(DHCommand*)command {
    DHLog(@"Abstract equipment received the command: %@. Descendants should override this method in order to be able to execute commands", command.name);
    return NO;
}

- (void)executeCommand:(DHCommand*)command
            completion:(DHCommandCompletionBlock)completion {
    DHLog(@"Abstract equipment received command: %@. Descendants should override this method in order to be able to execute commands", command.name);
    completion([DHCommandResult commandResultWithStatus:DHCommandStatusFailed result:nil]);
}

@end
