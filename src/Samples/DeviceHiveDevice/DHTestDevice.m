//
//  DHTestDevice.m
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHTestDevice.h"
#import "Configuration.h"
#import "DHTestEquipment.h"

NSString* const DHTestDeviceDidReceiveCommandNotification = @"DHTestDeviceDidReceiveCommandNotification";
NSString* const DHTestDeviceCommandKey = @"DHTestDeviceCommandKey";

@implementation DHTestDevice

- (id)initWithDeviceService:(id<DHDeviceService>)deviceService {
    DHNetwork* network = [[DHNetwork alloc] initWithName:@"Test iOS Network(Device Framwork)"
                                             description:@"Test iOS Device Network(Device Framwork)"];
    
    DHEquipment* equipment = [[DHTestEquipment alloc] init];
    
    DHDeviceClass* deviceClass = [[DHDeviceClass alloc] initWithName:@"Test iOS Device Class(Device Framwork)"
                                                             version:@"1.0"];
    
    DHDeviceData* deviceData = [[DHDeviceData alloc] initWithID:kDeviceId
                                                            key:kDeviceKey
                                                           name:@"Test iOS Device(Device Framwork)"
                                                         status:DHDeviceStatusOnline
                                                        network:network
                                                    deviceClass:deviceClass
                                                     equipments:@[equipment]];
    
    self  = [super initWithDeviceData:deviceData deviceService:deviceService];
    if (self) {
        
    }
    return self;
}

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)willStartRegistration {
    NSLog(@"DHTestDevice:willStartRegistration");
}

- (void)didFinishRegistration {
    NSLog(@"DHTestDevice:didFinishRegistration");
}

- (void)didFailRegistrationWithError:(NSError *)error {
    NSLog(@"DHTestDevice:didFailRegistrationWithError: %@", [error description]);
}

- (void)willSendNotification:(DHNotification*)notification {
    NSLog(@"DHTestDevice:willSendNotification: (%@)", notification.name);
}

- (void)didSendNotification:(DHNotification*)notification {
    NSLog(@"DHTestDevice:didSendNotification: (%@)", notification.name);
}

- (void)didFailSendNotification:(DHNotification*)notification
                      withError:(NSError*)error {
    NSLog(@"DHTestDevice:didFailSendNotification: (%@): withError: %@", notification.name, [error description]);
}

- (BOOL)shouldExecuteCommand:(DHCommand*)command {
    NSLog(@"DHTestDevice:shouldExecuteCommand: (%@)", command.name);
    return YES;
}

- (void)executeCommand:(DHCommand*)command
            completion:(DHCommandCompletionBlock)completion {
    NSLog(@"DHTestDevice:executeCommand: %@", command.name);
    [[NSNotificationCenter defaultCenter] postNotificationName:DHTestDeviceDidReceiveCommandNotification
                                                        object:self userInfo:@{DHTestDeviceCommandKey : command}];
    dispatch_async(dispatch_get_main_queue(), ^{
        completion([DHCommandResult commandResultWithStatus:DHCommandStatusCompleted
                                                     result:@"DHTestDevice:Finished!"]);
    });
}

@end
