//
//  DHEquipmentState.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/30/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHEntity.h"

/**
 Represents an equipment state.
 */
@interface DHEquipmentState : DHEntity

/**
 Equipment code.
 */
@property (nonatomic, strong, readonly) NSString* code;

/**
 Equipment state timestamp (UTC).
 */
@property (nonatomic, strong, readonly) NSString* timestamp;

/**
 Equipment state parameters.
 An object with an arbitrary structure.
 It can be built of NSDictionaries, NSArrays and primitive types.
 */
@property (nonatomic, strong, readonly) id parameters;


@end
