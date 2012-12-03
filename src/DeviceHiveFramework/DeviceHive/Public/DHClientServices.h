//
//  DHClientServices.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/30/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHClientService.h"
#import "DHRestfulApiClient.h"

/**
 This class provides a set of methods for obtaining a client service which implements and encapsulates network-related functionality.
 */
@interface DHClientServices : NSObject

/** Get RESTful client service implementation for given service URL address.
 @param url URL address of the server.
 @return Client service implementation which is used by the DHDeviceClient for performing it's tasks.
 */
+ (id<DHClientService>)restfulClientServiceWithUrl:(NSURL *)url;

/** Get RESTful client service implementation for given service URL address.
 @param url URL address of the server.
 @param username Username value to use for Basic Authorisation.
 @param password Password value to use for Basic Authorisation.
 @return Client service implementation which is used by the DHDeviceClient for performing it's tasks
 */
+ (id<DHClientService>)restfulClientServiceWithUrl:(NSURL *)url
                                          username:(NSString *)username
                                          password:(NSString *)password;

/** Get RESTful client service implementation with given DHRestfulApiClient implementation.
 @param restfulApiClient DHRestfulApiClient implemetation which will be used to init client service.
 @return Client service implementation which is used by the `DHDeviceClient` for performing its tasks.
 */
+ (id<DHClientService>)restfulClientServiceWithApiClient:(id<DHRestfulApiClient>)restfulApiClient;

@end
