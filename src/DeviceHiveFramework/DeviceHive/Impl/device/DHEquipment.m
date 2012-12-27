//
//  DHEquipment.m
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 10/27/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHEquipment.h"
#import "DHLog.h"
#import "DHCommandResult.h"
#import "DHCommand.h"
#import "DHEquipment+Private.h"
#import "DHEquipmentNotification.h"

@interface DHEquipment ()

@property (nonatomic, weak, readwrite) DHDevice* device;
@property (nonatomic, strong, readwrite) DHEquipmentData* equipmentData;

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


- (BOOL)registerEquipmentWithDevice:(DHDevice *)device {
    return YES;
}

- (BOOL)unregisterEquipmentWithDevice:(DHDevice *)device {
    return YES;
}

- (void)deviceWillBeginProcessingCommands:(DHDevice *)device {
    
}

- (void)deviceDidStopProcessingCommands:(DHDevice *)device {
    
}

#pragma mark - DHEquipmentProtocol

- (NSNumber *)equipmentID {
    return self.equipmentData.equipmentID;
}

- (NSString *)code {
    return self.equipmentData.code;
}

- (NSString *)name {
    return self.equipmentData.name;
}

- (NSString *)type {
    return self.equipmentData.type;
}

- (id)data {
    return self.equipmentData.data;
}

- (void)setData:(id)data {
    self.equipmentData.data = data;
}


#pragma mark - DHCommandExecutor

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
