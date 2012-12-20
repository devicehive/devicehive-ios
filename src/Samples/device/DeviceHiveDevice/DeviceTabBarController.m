//
//  DeviceTabBarController.m
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DeviceTabBarController.h"
#import "DHDeviceData.h"
#import "DHDevice.h"
#import "DHCommand.h"

NSString* const DeviceClientDidReceiveNotification = @"DeviceClientDidReceiveNotification";

@interface DeviceTabBarController () <UITabBarControllerDelegate>

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
    [super setSelectedViewController:selectedViewController];
    if ([selectedViewController respondsToSelector:@selector(setDevice:)]) {
        [selectedViewController performSelector:@selector(setDevice:)
                                     withObject:self.device];
    }
}


@end
