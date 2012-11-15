//
//  DHCommand.h
//  DeviceHiveDevice
//
//  Created by Alex Maydanik on 10/27/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHEntity.h"

/**
 Represents a device command, a unit of information sent to devices
 */
@interface DHCommand : DHEntity

/**
 Command identifier
 */
@property (nonatomic, strong, readonly) NSNumber * commandID;

/**
 Command timestamp (UTC)
 */
@property (nonatomic, strong, readonly) NSDate * timeStamp;

/**
 Command name
 */
@property (nonatomic, strong, readonly) NSString * name;

/**
 Command parameters
 */
@property (nonatomic, strong, readonly) NSDictionary * parameters;

/**
 Command status
 */
@property (nonatomic, strong, readonly) NSString * status;

/**
 Command execution result
 */
@property (nonatomic, strong, readonly) NSString * result;

/**
 Command lifetime, a number of seconds until this command expires
 */
@property (nonatomic, strong, readonly) NSNumber * lifetime;

/**
 Command identifier
 */
@property (nonatomic, strong, readonly) NSNumber * flags;

@end
