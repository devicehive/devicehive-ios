//
//  EMDeviceMO.h
//  EmbeddedControl
//
//  Created by  on 12.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMDeviceClassMO, EMNetworkMO, EMNotificationMO;

/**
 Instances of `EMDeviceMO` store information about devices. They also provide references to the lists of notifications, which are available for the devices, via `notifications` property. The latest notification stores information about current device's state.
 
 List of device's notifications can be updated using `getDeviceNotifications:success:failure:` method of `EMRESTClient`. Use `deviceLongPoll:completionBlock:` to monitor if there are any new notifications available for the device.
 
 Device's state can be updated from the client by sending commands with the help of `EMRESTClient`'s method named `sendCommand:toDevice:equipmentCode:value:success:failure:`.
 */
@interface EMDeviceMO : NSManagedObject
/**
 Device's unique identifier. Provided in GUID format
 */
@property (nonatomic, retain) NSString * id;
/**
 Name of the device
 */
@property (nonatomic, retain) NSString * name;
/**
 Current status of the device
 */
@property (nonatomic, retain) NSString * status;
/**
 Reference to the device class which the device belongs to
 */
@property (nonatomic, retain) EMDeviceClassMO *deviceClass;
/**
 Reference to the network device is registered in
 */
@property (nonatomic, retain) EMNetworkMO *network;
/**
 All notifications for the last 2 hours which are available for the device
 */
@property (nonatomic, retain) NSSet *notifications;
@end

@interface EMDeviceMO (CoreDataGeneratedAccessors)

- (void)addNotificationsObject:(EMNotificationMO *)value;
- (void)removeNotificationsObject:(EMNotificationMO *)value;
- (void)addNotifications:(NSSet *)values;
- (void)removeNotifications:(NSSet *)values;

@end
