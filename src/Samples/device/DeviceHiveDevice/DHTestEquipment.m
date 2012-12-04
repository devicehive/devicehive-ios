//
//  DHTestEquipment.m
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHTestEquipment.h"

@implementation DHTestEquipment

- (id)init {
    DHEquipmentData* data = [[DHEquipmentData alloc] initWithName:@"Test iOS Equipment"
                                                             code:@"Echo iOS Equipment code"
                                                             type:@"Echo iOS Equipment type"];
    self = [super initWithEquipmentData:data];
    if (self) {
        
    }
    return self;
}

- (BOOL)registerEquipmentWithDevice:(DHDevice *)device {
    NSLog(@"DHTestEquipment registering with device: %@", device.deviceData.name);
    return YES;
}

- (BOOL)unregisterEquipmentWithDevice:(DHDevice *)device {
    NSLog(@"DHTestEquipment unregistering...");
    return YES;
}

- (void)deviceWillBeginProcessingCommands:(DHDevice *)device {
    NSLog(@"DHTestEquipment:deviceWillBeginProcessingCommands");
}


- (void)deviceDidStopProcessingCommands:(DHDevice *)device {
    NSLog(@"DHTestEquipment:deviceDidStopProcessingCommands");
}

- (BOOL)shouldExecuteCommand:(DHCommand*)command {
    return YES;
}

- (void)executeCommand:(DHCommand*)command
            completion:(DHCommandCompletionBlock)completion {
    NSLog(@"DHTestEquipment received command: %@", command.name);
    completion([DHCommandResult commandResultWithStatus:DHCommandStatusCompleted
                                                 result:@"DHTestEquipment:Finished!"]);
}

@end
