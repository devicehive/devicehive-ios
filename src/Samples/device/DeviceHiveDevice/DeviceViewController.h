//
//  DeviceViewController.h
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHDevice;

@interface DeviceViewController : UITableViewController

@property (nonatomic, strong) DHDevice* device;

@end
