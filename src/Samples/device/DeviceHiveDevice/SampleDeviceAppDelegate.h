//
//  DHAppDelegate.h
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 10/15/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHDevice;
@protocol DHDeviceService;

@interface SampleDeviceAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) DHDevice* device;

+ (SampleDeviceAppDelegate *)sampleAppDelegate;

- (void)registerDeviceWithService:(id<DHDeviceService>)deviceService completion:(void (^)(BOOL success))completion;
- (void)registerDeviceWithServiceUrl:(NSString *)deviceServiceUrl completion:(void (^)(BOOL success))completion;

@end
