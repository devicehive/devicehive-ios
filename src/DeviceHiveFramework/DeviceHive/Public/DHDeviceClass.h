//
//  DHDeviceClass.h
//  DeviceHiveDevice
//
//  Created by Alex Maydanik on 10/27/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHEntity.h"

/**
 Represents a device class which holds meta-information about devices.
 */
@interface DHDeviceClass : DHEntity

/**
 Device class identifier.
 */
@property (nonatomic, strong, readonly) NSNumber* deviceClassID;

/**
 If set, specifies inactivity timeout in seconds before the framework changes device status to 'Offline'.
 */
@property (nonatomic, strong, readonly) NSNumber* offlineTimeout;

/**
 Indicates whether device class is permanent. Permanent device classes could not be modified by devices during registration.
 */
@property (nonatomic, readonly) BOOL isPermanent;

/**
 Device class display name.
 */
@property (nonatomic, strong, readonly) NSString * name;

/**
 Device class version.
 */
@property (nonatomic, strong, readonly) NSString * version;

/**
 Init object with given parameters.
 @param name Device display name.
 @param version Device class version.
 */
- (id)initWithName:(NSString*)name
           version:(NSString*)version;

/**
 Init object with given parameters.
 @param name Device display name.
 @param version Device class version.
 @param offlineTimeout Timeout in seconds before the framework changes device status to 'Offline'.
 */
- (id)initWithName:(NSString *)name
           version:(NSString *)version
    offlineTimeout:(NSNumber *)offlineTimeout;

/**
 Init object with given parameters.
 @param name Device display name.
 @param version Device class version.
 @param offlineTimeout Timeout in seconds before the framework changes device status to 'Offline'.
 @param permanent Indicates whether device class is permanent.
 */
- (id)initWithName:(NSString *)name
           version:(NSString *)version
    offlineTimeout:(NSNumber *)offlineTimeout
         permanent:(BOOL)permanent;

/**
 Init object with given parameters.
 @param deviceClassID Device class identifier.
 @param name Device display name.
 @param version Device class version.
 @param offlineTimeout Timeout in seconds before the framework changes device status to 'Offline'.
 @param permanent Indicates whether device class is permanent.
 */
- (id)initWithId:(NSNumber *)deviceClassID
            name:(NSString *)name
         version:(NSString *)version
  offlineTimeout:(NSNumber *)offlineTimeout
       permanent:(BOOL)permanent;

@end
