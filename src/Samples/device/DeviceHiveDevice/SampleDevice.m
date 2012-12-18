//
//  SampleDevice.m
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "SampleDevice.h"
#import "Configuration.h"
#import "SampleEquipment.h"

NSString* const SampleDeviceDidReceiveCommandNotification = @"SampleDeviceDidReceiveCommandNotification";
NSString* const SampleDeviceCommandKey = @"SampleDeviceCommandKey";

@implementation SampleDevice

- (id)initWithDeviceService:(id<DHDeviceService>)deviceService {
    DHNetwork* network = [[DHNetwork alloc] initWithName:@"Test iOS Network(Device Framework)"
                                             description:@"Test iOS Device Network(Device Framework)"];
    
    DHEquipment* equipment = [[SampleEquipment alloc] init];
    
    DHDeviceClass* deviceClass = [[DHDeviceClass alloc] initWithName:@"Test iOS Device Class(Device Framework)"
                                                             version:@"1.0"
                                                      offlineTimeout:0];
    
    DHDeviceData* deviceData = [[DHDeviceData alloc] initWithID:kDeviceId
                                                            key:kDeviceKey
                                                           name:@"Test iOS Device(Device Framework)"
                                                         status:DHDeviceStatusOnline
                                                        network:network
                                                    deviceClass:deviceClass
                                                      equipment:@[equipment]];
    
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
    NSLog(@"SampleDevice:willStartRegistration");
}

- (void)didFinishRegistration {
    NSLog(@"SampleDevice:didFinishRegistration");
}

- (void)didFailRegistrationWithError:(NSError *)error {
    NSLog(@"SampleDevice:didFailRegistrationWithError: %@", [error description]);
}

- (void)willBeginProcessingCommands {
    NSLog(@"SampleDevice:willBeginProcessingCommands");
}

- (void)didStopProcessingCommands {
    NSLog(@"SampleDevice:didStopProcessingCommands");
}

- (void)willSendNotification:(DHNotification*)notification {
    NSLog(@"SampleDevice:willSendNotification: (%@)", notification.name);
}

- (void)didSendNotification:(DHNotification*)notification {
    NSLog(@"SampleDevice:didSendNotification: (%@)", notification.name);
}

- (void)didFailSendNotification:(DHNotification*)notification
                      withError:(NSError*)error {
    NSLog(@"SampleDevice:didFailSendNotification: (%@): withError: %@", notification.name, [error description]);
}

- (void)willExecuteCommand:(DHCommand *)command {
    NSLog(@"SampleDevice:willExecuteCommand: (%@)", command.name);
    [[NSNotificationCenter defaultCenter] postNotificationName:SampleDeviceDidReceiveCommandNotification
                                                        object:self userInfo:@{SampleDeviceCommandKey : command}];
}

- (void)executeCommand:(DHCommand*)command
            completion:(DHCommandCompletionBlock)completion {
    NSLog(@"SampleDevice:executeCommand: %@", command.name);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion([DHCommandResult commandResultWithStatus:DHCommandStatusCompleted
                                                     result:@"SampleDevice:Finished!"]);
    });
}

@end
