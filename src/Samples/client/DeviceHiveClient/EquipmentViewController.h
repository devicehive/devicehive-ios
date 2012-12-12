//
//  EquipmentViewController.h
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/12/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DHClientService;
@class DHDeviceClient;

@interface EquipmentViewController : UITableViewController

@property (nonatomic, strong) DHDeviceClient* deviceClient;

@end
