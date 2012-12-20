//
//  DHEquipmentNotification.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHNotification.h"

/**
 Represents a notification which is usually sent by an equipment.
 */
@interface DHEquipmentNotification : DHNotification

/**
 Init object with given parameters.
 @param equipmentCode Equipment code.
 @param name Parameters key name in the `Notification`'s parameters.
 @param value Equipment parameters.
 */
- (id)initWithEquipmentCode:(NSString *)equipmentCode
             parametersName:(NSString *)name
                 parameters:(NSDictionary *)value;

@end
