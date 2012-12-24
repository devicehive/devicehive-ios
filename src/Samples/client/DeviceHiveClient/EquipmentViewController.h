//
//  EquipmentViewController.h
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/12/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTabBarController.h"

@protocol DHClientService;
@class DHSingleDeviceClient;

@interface EquipmentViewController : UITableViewController<Refreshable>

@property (nonatomic, strong) DHSingleDeviceClient* deviceClient;

@end
