//
//  DHTestDevice.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHDevice.h"

extern NSString* const DHTestDeviceDidReceiveCommandNotification;
extern NSString* const DHTestDeviceCommandKey;

@interface DHTestDevice : DHDevice

- (id)initWithDeviceService:(id<DHDeviceService>)deviceService;

@end
