//
//  DHAppDelegate.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 10/15/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHDevice;

@interface DHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) DHDevice* device;

@end
