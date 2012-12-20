//
//  NotificationsViewController.m
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "CommandsViewController.h"
#import "DeviceTabBarController.h"
#import "SampleDevice.h"
#import "DHCommand.h"

@interface CommandsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@end

@implementation CommandsViewController

- (void)setDevice:(DHDevice *)device {
    if (_device != device) {
        if (_device) {
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:SampleDeviceDidReceiveCommandNotification
                                                          object:_device];
        }
        _device = device;
        if (_device) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(deviceClientDidReceiveNotification:)
                                                         name:SampleDeviceDidReceiveCommandNotification
                                                       object:_device];
        }
    }
}

- (void)dealloc {
    self.device = nil;
}

- (void)deviceClientDidReceiveNotification:(NSNotification *)notification {
    DHCommand* deviceCommand = notification.userInfo[SampleDeviceCommandKey];
    self.logTextView.text = [NSString stringWithFormat:@"%@\n%@", self.logTextView.text, [deviceCommand description]];
}


@end
