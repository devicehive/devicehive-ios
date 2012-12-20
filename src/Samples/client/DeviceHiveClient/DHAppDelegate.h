//
//  DHAppDelegate.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 10/15/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DHClientService;


@interface DHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) id<DHClientService> clientService;

+ (DHAppDelegate*)appDelegate;

- (void)setupClientServiceWithServerUrl:(NSString *)url
                               username:(NSString *)username
                               password:(NSString *)password;

@end
