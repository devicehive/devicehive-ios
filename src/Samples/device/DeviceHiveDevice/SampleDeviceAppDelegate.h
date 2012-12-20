//
//  DHAppDelegate.h
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 10/15/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHDevice;

@interface SampleDeviceAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) DHDevice* device;

@end
