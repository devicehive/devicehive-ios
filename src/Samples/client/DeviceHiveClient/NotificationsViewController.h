//
//  NotificationsViewController.h
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHDeviceClient;

@interface NotificationsViewController : UITableViewController

@property (nonatomic, strong) DHDeviceClient* deviceClient;

@end
