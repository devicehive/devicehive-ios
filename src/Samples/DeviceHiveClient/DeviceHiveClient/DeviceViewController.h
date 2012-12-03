//
//  DHViewController.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 10/15/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHClientService.h"

@interface DeviceViewController : UIViewController

@property (nonatomic, strong) id<DHClientService> clientService;
@property (nonatomic, strong) DHDeviceData* deviceData;

@end
