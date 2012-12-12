//
//  EMDeviceClassMO.h
//  EmbeddedControl
//
//  Created by  on 12.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMDeviceMO;

/**
 `EMDeviceClassMO` stores information about the whole class of devices. It also provides references to all possible devices of the class and to all equipment which is available on the devices of the class.
 
 Information about device classes is received indirectly during `getDeviceListFromNetwork:success:failure:` method call. Call `EMRESTClient`'s method named `updateDeviceClass:success:failure:` to update information about specific class of devices.
 */
@interface EMDeviceClassMO : NSManagedObject
/**
 Device class identifier
 */
@property (nonatomic, retain) NSNumber * id;
/**
 Device class name
 */
@property (nonatomic, retain) NSString * name;
/**
 Version of device class
 */
@property (nonatomic, retain) NSString * version;
/**
 Stores references to all available devices of the class
 */
@property (nonatomic, retain) NSSet *devices;
/**
 Stores references to equipment which is available on the devices of the class
 */
@property (nonatomic, retain) NSSet *equipment;
@end

@interface EMDeviceClassMO (CoreDataGeneratedAccessors)

- (void)addDevicesObject:(EMDeviceMO *)value;
- (void)removeDevicesObject:(EMDeviceMO *)value;
- (void)addDevices:(NSSet *)values;
- (void)removeDevices:(NSSet *)values;

- (void)addEquipmentObject:(NSManagedObject *)value;
- (void)removeEquipmentObject:(NSManagedObject *)value;
- (void)addEquipment:(NSSet *)values;
- (void)removeEquipment:(NSSet *)values;

@end
