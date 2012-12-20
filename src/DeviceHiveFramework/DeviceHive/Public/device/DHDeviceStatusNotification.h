//
//  DHDeviceStatusNotification.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/9/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHNotification.h"

/**
 `OK` device status.
 */
extern NSString* const DHDeviceStatusOk;

/**
 `Online` device status.
 */
extern NSString* const DHDeviceStatusOnline;


/**
 Represents a device status notification which is sent by device.
 */
@interface DHDeviceStatusNotification : DHNotification

/**
 Init notification with given status.
 @param deviceStatus Status value (see DHDeviceStatusOnline, DHDeviceStatusOK).
 */
- (id)initWithDeviceStatus:(NSString *)deviceStatus;

/**
 Constructs DHDeviceStatusNotification object with DHDeviceStatusOnline status.
 */
+ (id)onlineStatusNotification;

/**
 Constructs DHDeviceStatusNotification object with DHDeviceStatusOk status.
 */
+ (id)okStatusNotification;

@end
