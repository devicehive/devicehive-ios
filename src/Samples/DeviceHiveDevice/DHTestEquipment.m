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

- (void)registerEquipmentWithCompletion:(DHEquipmentOperationCompletionBlock)completion {
    NSLog(@"DHTestEquipment registering...");
    completion(YES);
}

- (void)unregisterEquipmentWithCompletion:(DHEquipmentOperationCompletionBlock)completion {
    NSLog(@"DHTestEquipment unregistering...");
    completion(YES);
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
