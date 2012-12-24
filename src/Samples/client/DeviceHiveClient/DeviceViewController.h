//
//  DeviceViewController.h
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTabBarController.h"

@protocol DHClientService;
@class DHSingleDeviceClient;

@interface DeviceViewController : UITableViewController<Refreshable>

@property (nonatomic, strong) DHSingleDeviceClient* deviceClient;

@end
