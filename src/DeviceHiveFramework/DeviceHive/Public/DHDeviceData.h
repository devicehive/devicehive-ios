//
//  DHDeviceData.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/13/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHEntity.h"

@class DHNetwork, DHDeviceClass;

/**
 Represents device's serializable data.
 */
@interface DHDeviceData : DHEntity

/**
 Device unique identifier.
 */
@property (nonatomic, strong, readonly) NSString * deviceID;

/**
 Device authentication key. The key maximum length is 64 characters.
 */
@property (nonatomic, strong, readonly) NSString * key;

/**
 Device display name.
 */
@property (nonatomic, strong, readonly) NSString * name;

/**
 Device operation status.
 */
@property (nonatomic, strong, readonly) NSString * status;

/**
 Associated DHNetwork object.
 */
@property (nonatomic, strong, readonly) DHNetwork  * network;

/**
 Associated DHDeviceClass object.
 */
@property (nonatomic, strong, readonly) DHDeviceClass * deviceClass;

/**
 Array of equipment objects to be associated with the device class.
 */
@property (nonatomic, strong, readonly) NSArray * equipment;

/**
 Device data, an object with an arbitrary structure. 
 It can be built of NSDictionaries, NSArrays and primitive types.
 Device data can only be set before registration.
 */
@property (nonatomic, strong) id data;

/**
 Init object with given parameters.
 @param deviceID Device unique identifier.
 @param key Device authentication key.
 @param name Device display name.
 @param status Device operation status.
 @param network Associated DHNetwork object.
 @param deviceClass Associated DHDeviceClass object.
 @param equipment Array of equipment objects.
 */
- (id)initWithID:(NSString*)deviceID
             key:(NSString*)key
            name:(NSString*)name
          status:(NSString*)status
         network:(DHNetwork*)network
     deviceClass:(DHDeviceClass*)deviceClass
       equipment:(NSArray*)equipment;

/**
 Init object with given parameters.
 @param deviceID Device unique identifier.
 @param key Device authentication key.
 @param name Device display name.
 @param status Device operation status.
 @param network Associated DHNetwork object.
 @param deviceClass Associated DHDeviceClass object.
 */
- (id)initWithID:(NSString*)deviceID
             key:(NSString*)key
            name:(NSString*)name
          status:(NSString*)status
         network:(DHNetwork*)network
     deviceClass:(DHDeviceClass*)deviceClass;

/**
 Init object with given parameters. Intitially the device isn't assigned to any network.
 @param deviceID Device unique identifier.
 @param key Device authentication key.
 @param name Device display name.
 @param status Device operation status.
 @param deviceClass Associated DHDeviceClass object.
 */
- (id)initWithID:(NSString*)deviceID
             key:(NSString*)key
            name:(NSString*)name
          status:(NSString*)status
     deviceClass:(DHDeviceClass*)deviceClass;

/**
 Init object with given parameters. Intitially the device isn't assigned to any network.
 @param deviceID Device unique identifier.
 @param key Device authentication key.
 @param name Device display name.
 @param status Device operation status.
 @param deviceClass Associated DHDeviceClass object.
 @param equipment Array of equipment objects.
 */
- (id)initWithID:(NSString*)deviceID
             key:(NSString*)key
            name:(NSString*)name
          status:(NSString*)status
     deviceClass:(DHDeviceClass*)deviceClass
       equipment:(NSArray*)equipment;

@end
