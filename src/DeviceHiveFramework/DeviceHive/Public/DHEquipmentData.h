//
//  DHEquipmentData.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/13/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHEntity.h"
#import "DHEquipmentProtocol.h"

/**
 Represents equipment's serializable data.
 */
@interface DHEquipmentData : DHEntity<DHEquipmentProtocol>

/**
 Init object with given parameters.
 @param equipmentID Equipment identifier.
 @param name Equipment display name.
 @param code Equipment code.
 @param type Equipment type.
 */
- (id)initWithId:(NSNumber *)equipmentID
            name:(NSString *)name
            code:(NSString *)code
            type:(NSString *)type;

/**
 Init object with given parameters.
 @param name Equipment display name.
 @param code Equipment code.
 @param type Equipment type.
 */
- (id)initWithName:(NSString *)name
              code:(NSString *)code
              type:(NSString *)type;

@end
