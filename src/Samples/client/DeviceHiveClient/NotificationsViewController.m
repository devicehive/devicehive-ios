//
//  NotificationsViewController.m
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "NotificationsViewController.h"
#import "DeviceTabBarController.h"
#import "DHNotification.h"

@interface NotificationsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@end

@implementation NotificationsViewController

- (void)setDeviceClient:(DHDeviceClient *)deviceClient {
    if (_deviceClient != deviceClient) {
        if (_deviceClient) {
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:DeviceClientDidReceiveNotification
                                                          object:_deviceClient];
        }
        _deviceClient = deviceClient;
        if (_deviceClient) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(deviceClientDidReceiveNotification:)
                                                         name:DeviceClientDidReceiveNotification
                                                       object:_deviceClient];
        }
    }
}

- (void)deviceClientDidReceiveNotification:(NSNotification *)notification {
    DHNotification* deviceNotification = notification.userInfo[@"notification"];
    self.logTextView.text = [NSString stringWithFormat:@"%@\n%@", self.logTextView.text, [deviceNotification description]];
}


@end
