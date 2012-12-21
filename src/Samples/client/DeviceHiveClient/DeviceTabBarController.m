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
    if ([selectedViewController conformsToProtocol:@protocol(Refreshable)]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                               target:self
                                                                                               action:@selector(refreshButtonClicked:)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
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

- (void)refreshButtonClicked:(UIBarButtonItem *)sender {
    if ([self.selectedViewController conformsToProtocol:@protocol(Refreshable)]) {
        UIViewController<Refreshable>* refreshableViewController = (UIViewController<Refreshable> *)self.selectedViewController;
        [refreshableViewController refresh];
    }
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
