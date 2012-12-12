//
//  EMNetworkMO.h
//  EmbeddedControl
//
//  Created by  on 12.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMDeviceMO;

/**
 `EMNetworkMO` is `NSManagedObject`'s subclass which stores the most signficant information about network. An instance of the class also stores a set of devices which belong to the network.
 
 To update the whole list of available networks, call `getNetworkList:failure:` method of `EMRESTClient` instance.
 */
@interface EMNetworkMO : NSManagedObject
/**
 Network identifier
 */
@property (nonatomic, retain) NSNumber * id;
/**
 Network name
 */
@property (nonatomic, retain) NSString * name;
/**
 Short description of the network
 */
@property (nonatomic, retain) NSString * netwDescription;
/** A set of devices which are available in the network. 
 
 This property is filled only after the user called `getDeviceListFromNetwork:success:failure:` method of `EMRESTClient` instance
 */
@property (nonatomic, retain) NSSet *devices;
@end

@interface EMNetworkMO (CoreDataGeneratedAccessors)

- (void)addDevicesObject:(EMDeviceMO *)value;
- (void)removeDevicesObject:(EMDeviceMO *)value;
- (void)addDevices:(NSSet *)values;
- (void)removeDevices:(NSSet *)values;

@end
