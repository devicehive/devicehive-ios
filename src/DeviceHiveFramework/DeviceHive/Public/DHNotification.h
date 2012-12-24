//
//  DHNotification.h
//  DeviceHiveDevice
//
//  Created by Alex Maydanik on 10/27/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHEntity.h"

/**
 Represents a device notification, a unit of information dispatched from devices.
 */
@interface DHNotification : DHEntity

/**
 Notification identifier.
 */
@property (nonatomic, strong, readonly) NSString* notificationID;

/**
 Notification timestamp (UTC).
 */
@property (nonatomic, strong, readonly) NSString* timestamp;

/**
 Notification name.
 */
@property (nonatomic, strong, readonly) NSString* name;

/**
 Notification parameters.
 */
@property (nonatomic, strong, readonly) id parameters;

/**
 Init object with name and parameters.
 @param name Notification name.
 @param parameters Notification parameters.
 */
- (id)initWithName:(NSString *)name
        parameters:(id)parameters;

@end
