//
//  DeviceTabBarController.h
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const DeviceClientDidReceiveNotification;

@class DHDeviceData;
@class DHDeviceClient;
@protocol DHClientService;

@interface DeviceTabBarController : UITabBarController

@property (nonatomic, strong) DHDeviceClient* deviceClient;

@end
