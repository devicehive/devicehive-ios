//
//  DHDeviceHive.m
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHDeviceServices.h"
#import "DHLog.h"
#import "DHDefaultRestfulApiClient.h"
#import "DHRestfulDeviceService.h"

@implementation DHDeviceServices

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (id<DHDeviceService>)restfulDeviceServiceWithUrl:(NSURL*)url {
    DHDefaultRestfulApiClient* restfulApiClient = [[DHDefaultRestfulApiClient alloc] initWithBaseURL:url];
    restfulApiClient.timeoutInterval = 120; // 2 min
    return [self restfulDeviceServiceWithApiClient:restfulApiClient];
}

+ (id<DHDeviceService>)restfulDeviceServiceWithApiClient:(id<DHRestfulApiClient>)restfulApiClient {
    return [[DHRestfulDeviceService alloc] initWithApiClient:restfulApiClient];
}

@end
