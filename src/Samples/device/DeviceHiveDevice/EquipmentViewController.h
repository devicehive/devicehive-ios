//
//  EquipmentViewController.h
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 12/13/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHDevice;

@interface EquipmentViewController : UITableViewController

@property (nonatomic, strong) DHDevice* device;

@end
