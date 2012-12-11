//
//  SampleDevice.h
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHDevice.h"

extern NSString* const SampleDeviceDidReceiveCommandNotification;
extern NSString* const SampleDeviceCommandKey;

@interface SampleDevice : DHDevice

- (id)initWithDeviceService:(id<DHDeviceService>)deviceService;

@end
