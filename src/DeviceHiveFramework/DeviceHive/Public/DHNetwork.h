//
//  DHNetwork.h
//  DeviceHiveDevice
//
//  Created by Alex Maydanik on 10/27/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHEntity.h"

/**
 Represents a network, an isolated area where devices reside.
 */
@interface DHNetwork : DHEntity

/**
 Network identifier
 */
@property (nonatomic, strong) NSString* networkID;

/**
 Network display name
 */
@property (nonatomic, strong) NSString* name;

/**
 Network description
 */
@property (nonatomic, strong) NSString* description;

/**
 Optional key that is used to protect the network from unauthorized device registrations
 */
@property (nonatomic, strong) NSString* key;

/**
 Init object with name and parameters.
 @param name Network display name
 @param description Network description
 */
- (id)initWithName:(NSString*)name
       description:(NSString*)description;

/**
 Init object with given parameters.
 @param name Network display name
 @param networkId Network identifier
 @param description Network description
 @param key Network key
 */
- (id)initWithName:(NSString*)name
         networkId:(NSString*)networkId
       description:(NSString*)description
               key:(NSString*)key;

@end
