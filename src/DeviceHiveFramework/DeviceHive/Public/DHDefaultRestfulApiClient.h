//
//  DHDeviceApi.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 10/15/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHRestfulApiClient.h"

/**
  Default implementation of `DHRestfulApiClient` protocol.
 */
@interface DHDefaultRestfulApiClient : NSObject<DHRestfulApiClient>

/**
 Init object with the given server URL address.
 @param url Server's URL address.
 */
- (id)initWithBaseURL:(NSURL*)url;

@end
