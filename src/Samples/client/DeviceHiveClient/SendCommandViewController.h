//
//  SendCommandViewController.h
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHSingleDeviceClient;

@interface SendCommandViewController : UITableViewController

@property (nonatomic, strong) DHSingleDeviceClient* deviceClient;

@end
