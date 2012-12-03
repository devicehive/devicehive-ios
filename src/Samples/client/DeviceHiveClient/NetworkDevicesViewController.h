//
//  NetworkDevicesViewController.h
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/3/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DHClientService;
@class DHNetwork;

@interface NetworkDevicesViewController : UITableViewController

@property (nonatomic, strong) id<DHClientService> clientService;
@property (nonatomic, strong) DHNetwork* network;

@end
