//
//  DHEquipmentProtocol.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 12/14/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Represents equipment public interface.
 */
@protocol DHEquipmentProtocol <NSObject>

/**
 Equipment identifier
 */
@property (nonatomic, strong, readonly) NSNumber* equipmentID;

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

@end