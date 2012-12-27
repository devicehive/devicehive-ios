//
//  DHCommand.h
//  DeviceHiveFramework
//
//  Created by Alex Maydanik on 10/27/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHEntity.h"

/**
 Represents a device command, a unit of information sent to devices.
 */
@interface DHCommand : DHEntity

/**
 Command identifier.
 */
@property (nonatomic, strong, readonly) NSNumber * commandID;

/**
 Command timestamp (UTC).
 */
@property (nonatomic, strong, readonly) NSString * timeStamp;

/**
 Command name.
 */
@property (nonatomic, strong, readonly) NSString * name;

/**
 Command parameters.
 */
@property (nonatomic, strong, readonly) id parameters;

/**
 Command status.
 */
@property (nonatomic, strong, readonly) NSString * status;

/**
 Command execution result. Object with arbitraty structure.
 */
@property (nonatomic, strong, readonly) id result;

/**
 Command lifetime, a number of seconds until this command expires.
 */
@property (nonatomic, strong, readonly) NSNumber * lifetime;

/**
 Command flags. Optional value that could be supplied for device or related infrastructure.
 */
@property (nonatomic, strong, readonly) NSNumber * flags;

/**
 Init object with given parameters.
 @param name Command name.
 @param parameters Command parameters dictionary.
 */
- (id)initWithName:(NSString *)name
        parameters:(id)parameters;

/**
 Init object with given parameters.
 @param name Command name.
 @param parameters Command parameters dictionary.
 @param lifetime Number of seconds until this command expires.
 @param flags Command flags.
 */
- (id)initWithName:(NSString *)name
        parameters:(id)parameters
          lifetime:(NSNumber *)lifetime
             flags:(NSNumber *)flags;

@end
