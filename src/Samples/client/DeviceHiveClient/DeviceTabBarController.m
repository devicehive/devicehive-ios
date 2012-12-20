//
//  DeviceTabBarController.m
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DeviceTabBarController.h"
#import "DHDeviceData.h"
#import "DHDeviceClient.h"
#import "DHDeviceClient.h"
#import "DHCommand.h"

NSString* const DeviceClientDidReceiveNotification = @"DeviceClientDidReceiveNotification";

@interface DeviceTabBarController () <UITabBarControllerDelegate, DHDeviceClientDelegate>

@end

@implementation DeviceTabBarController 

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    if ([selectedViewController respondsToSelector:@selector(setDeviceClient:)]) {
        [selectedViewController performSelector:@selector(setDeviceClient:)
                                     withObject:self.deviceClient];
    }
    [super setSelectedViewController:selectedViewController];
}

- (void)setDeviceClient:(DHDeviceClient *)deviceClient {
    if (_deviceClient.deviceData != deviceClient.deviceData) {
        [_deviceClient stopReceivingNotifications];
        _deviceClient = deviceClient;
    }
    _deviceClient.delegate = self;
    if (!_deviceClient.isReceivingNotifications) {
        [_deviceClient beginReceivingNotifications];
    }
}

- (void)dealloc {
    [_deviceClient stopReceivingNotifications];
    _deviceClient.delegate = nil;
}

#pragma mark - DHDeviceClientDelegate


- (void)deviceClient:(DHDeviceClient *)client didReceiveNotification:(DHNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:DeviceClientDidReceiveNotification
                                                        object:self.deviceClient
                                                      userInfo:@{@"notification" : notification}];
}

- (void)deviceClientWillBeginReceivingNotifications:(DHDeviceClient *)client {
    NSLog(@"deviceClientWillBeginReceivingNotifications");
}

- (void)deviceClientDidStopReceivingNotifications:(DHDeviceClient *)client {
    NSLog(@"deviceClientDidStopReceivingNotifications");
}

- (void)deviceClient:(DHDeviceClient *)client willSendCommand:(DHCommand *)command {
     NSLog(@"deviceClient:willSendCommand:%@", command.name);
}

- (void)deviceClient:(DHDeviceClient *)client didSendCommand:(DHCommand *)command {
    NSLog(@"deviceClient:didSendCommand:%@", command.name);
}

- (void)deviceClient:(DHDeviceClient *)client didFailSendCommand:(DHCommand *)command withError:(NSError *)error {
    NSLog(@"deviceClient:didFailSendCommand:%@", command.name);
}


@end
