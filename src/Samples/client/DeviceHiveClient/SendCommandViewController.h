//
//  SendCommandViewController.h
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHDeviceClient;

@interface SendCommandViewController : UITableViewController

@property (nonatomic, strong) DHDeviceClient* deviceClient;

@end
