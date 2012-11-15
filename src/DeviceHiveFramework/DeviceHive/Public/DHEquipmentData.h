//
//  DHEquipmentData.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/13/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHEntity.h"

/**
 Represents equipment's serializable data.
 */
@interface DHEquipmentData : DHEntity

/**
 Equipment identifier
 */
@property (nonatomic, strong, readonly) NSString* equipmentID;

/**
 Equipment display name
 */
@property (nonatomic, strong, readonly) NSString* name;

/**
 Equipment code. It's used to reference particular equipment and it should be unique within a device class.
 */
@property (nonatomic, strong, readonly) NSString* code;

/**
 Equipment type. An arbitrary string representing equipment capabilities
 */
@property (nonatomic, strong, readonly) NSString* type;

/**
 Init object with given parameters.
 @param name Equipment display name
 @param code Equipment code
 @param type Equipment type
 */
- (id)initWithName:(NSString*)name
              code:(NSString*)code
              type:(NSString*)type;

@end
