//
//  DHDeviceHive.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHDeviceService.h"
#import "DHRestfulApiClient.h"

/**
 Device service protocol type definition.
 */
typedef enum : NSUInteger {
    /** Restful protocol. */
    DHDeviceServiceProcotolRestful,
    /** Binary protocol.
     * Binary protocol device service hasn't been implemented yet.
     */
    DHDeviceServiceProcotolBinary
} DHDeviceServiceProcotol;


/**
 `DHDeviceHive` class is a starting point from which you will begin using Device Hive in your app. This class provides a set of methods
 for obtaining a device service which implements and encapsulates device registration logic, command polling and dispatching mechanism
 and also posting notifications.
 */
@interface DHDeviceServices : NSObject

/** Get device service implementation for given protocol and service URL address.
 @param protocol DHDeviceServiceProcotol type which requested device service should implement
 @param url URL address of the server
 @return Device service implementation which is used by the Device for performing it's tasks
 */
+ (id<DHDeviceService>)deviceServiceForProtocol:(DHDeviceServiceProcotol)protocol
                                     serviceUrl:(NSURL*)url;

/** Get RESTful device service implementation for given service URL address.
 @param url URL address of the server
 @return Device service implementation which is used by the Device for performing it's tasks
 */
+ (id<DHDeviceService>)restfulDeviceServiceWithUrl:(NSURL*)url;

/** Get RESTful device service implementation with given DHRestfulApiClient implementation.
 @param restfulApiClient DHRestfulApiClient implemetation which will be used to init device service 
 @return Device service implementation which is used by the Device for performing it's tasks
 */
+ (id<DHDeviceService>)restfulDeviceServiceWithApiClient:(id<DHRestfulApiClient>)restfulApiClient;

@end
