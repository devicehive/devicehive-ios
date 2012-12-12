//
//  EMEquipmentMO.h
//  EmbeddedControl
//
//  Created by  on 13.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EMDeviceClassMO;

/**
 `EMEquipmentMO` stores information about a piece of equipment which is available for the specified device class
 */
@interface EMEquipmentMO : NSManagedObject
/**
 Code of equimpent which is necessary to execute commands on devices
 */
@property (nonatomic, retain) NSString * code;
/**
 Equipment's unique identifier
 */
@property (nonatomic, retain) NSNumber * id;
/**
 Name of the equipment
 */
@property (nonatomic, retain) NSString * name;
/**
 Equipment type (e.g. temperature sensor, LED, etc.)
 */
@property (nonatomic, retain) NSString * type;
/**
 Reference to the parent device class of equipment
 */
@property (nonatomic, retain) EMDeviceClassMO *deviceClass;

@end
