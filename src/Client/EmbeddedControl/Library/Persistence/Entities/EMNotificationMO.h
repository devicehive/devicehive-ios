//
//  EMNotificationMO.h
//  EmbeddedControl
//
//  Created by  on 12.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMDeviceMO;

/**
 `EMNotificationMO` stores information about an event which can happen on a device. Its main purpose is to provide the most recent device's state to all client devices.
 */
@interface EMNotificationMO : NSManagedObject
/**
 Notification's unique identifier
 */
@property (nonatomic, retain) NSNumber * id;
/**
 Message which is delivered in notification
 */
@property (nonatomic, retain) NSString * notification;
/**
 Notification's timestamp
 */
@property (nonatomic, retain) NSDate * timestamp;
/**
 Equipment code which identifies a piece of equipment affected by an event on the device
 */
@property (nonatomic, retain) NSString * equipmentCode;
/**
 New value for the device's status
 */
@property (nonatomic, retain) NSNumber * value;
/**
 Device for which the notificaton arrives
 */
@property (nonatomic, retain) EMDeviceMO *device;

@end
