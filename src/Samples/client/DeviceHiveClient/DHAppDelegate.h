//
//  DHAppDelegate.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 10/15/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DHClientService;


@interface DHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) id<DHClientService> clientService;

@end
