//
//  DHDeviceServices.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHDeviceService.h"
#import "DHRestfulApiClient.h"


/**
 This class provides a set of methods for obtaining a device service which implements and encapsulates device registration logic, command polling and dispatching mechanism and also posting notifications.
 */
@interface DHDeviceServices : NSObject

/** Get RESTful device service implementation for given service URL address.
 @param url URL address of the server.
 @return Device service implementation which is used by the Device for performing it's tasks.
 */
+ (id<DHDeviceService>)restfulDeviceServiceWithUrl:(NSURL*)url;

/** Get RESTful device service implementation with given DHRestfulApiClient implementation.
 @param restfulApiClient DHRestfulApiClient implemetation which will be used to init device service .
 @return Device service implementation which is used by the Device for performing it's tasks.
 */
+ (id<DHDeviceService>)restfulDeviceServiceWithApiClient:(id<DHRestfulApiClient>)restfulApiClient;

@end
