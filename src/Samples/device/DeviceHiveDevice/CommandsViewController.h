//
//  NotificationsViewController.h
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 12/11/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHDevice;

@interface CommandsViewController : UITableViewController

@property (nonatomic, strong) DHDevice* device;

@end
