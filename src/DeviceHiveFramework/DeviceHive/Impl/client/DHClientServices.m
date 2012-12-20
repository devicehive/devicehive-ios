//
//  DHClientServices.m
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/30/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHClientServices.h"
#import "DHRestfulClientService.h"
#import "DHDefaultRestfulApiClient.h"

@implementation DHClientServices

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (id<DHClientService>)restfulClientServiceWithUrl:(NSURL*)url {
    return [self restfulClientServiceWithUrl:url username:nil password:nil];
}

+ (id<DHClientService>)restfulClientServiceWithUrl:(NSURL *)url
                                          username:(NSString *)username
                                          password:(NSString *)password {
    
    DHDefaultRestfulApiClient* restfulApiClient = [[DHDefaultRestfulApiClient alloc] initWithBaseURL:url];
    restfulApiClient.timeoutInterval = 40; // 40 seconds
    [restfulApiClient setAuthorisationWithUsername:username password:password];
    return [self restfulClientServiceWithApiClient:restfulApiClient];
}

+ (id<DHClientService>)restfulClientServiceWithApiClient:(id<DHRestfulApiClient>)restfulApiClient {
    return [[DHRestfulClientService alloc] initWithApiClient:restfulApiClient];
}


@end
