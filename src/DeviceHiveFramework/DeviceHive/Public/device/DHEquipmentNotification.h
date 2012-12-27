//
//  DHEquipmentNotification.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHNotification.h"

/**
 Represents a notification which is usually sent by an equipment to update its state.
 */
@interface DHEquipmentNotification : DHNotification

/**
 Init object with given parameters.
 @param equipmentCode Equipment code.
 @param parameters Additional equipment parameters.
 */
- (id)initWithEquipmentCode:(NSString *)equipmentCode
                 parameters:(NSDictionary *)parameters;

@end
