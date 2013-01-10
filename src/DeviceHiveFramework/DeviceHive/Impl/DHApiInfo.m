//
//  DHApiInfo.m
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 1/10/13.
//  Copyright (c) 2013 DataArt Apps. All rights reserved.
//

#import "DHApiInfo.h"
#import "DHEntity+SerializationPrivate.h"
#import "NSMutableDictionary+DHEntitySerialization.h"

@implementation DHApiInfo

- (id)initWithApiVersion:(NSString *)apiVersion
         serverTimestamp:(NSString *)serverTimestamp
      webSocketServerUrl:(NSString *)webSocketServerUrl {
    self = [super init];
    if (self) {
        _apiVersion = apiVersion;
        _serverTimestamp = serverTimestamp;
        _webSocketServerUrl = webSocketServerUrl;
    }
    return self;
}

- (NSDictionary *)classDictionary {
    NSMutableDictionary* resultDict = [NSMutableDictionary dictionary];
    [resultDict setObjectIfNotNull:self.apiVersion forKey:@"apiVersion"];
    [resultDict setObjectIfNotNull:self.serverTimestamp forKey:@"serverTimestamp"];
    [resultDict setObjectIfNotNull:self.webSocketServerUrl forKey:@"webSocketServerUrl"];
    return [NSDictionary dictionaryWithDictionary:resultDict];
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
    return [self initWithApiVersion:dictionary[@"apiVersion"]
                    serverTimestamp:dictionary[@"serverTimestamp"]
                 webSocketServerUrl:dictionary[@"webSocketServerUrl"]];
}

- (NSString*)description {
	return [NSString stringWithFormat:@"<%@: %p, apiVersion: %@, serverTimestamp: %@, webSocketServerUrl: %@>",
            NSStringFromClass([self class]), self, self.apiVersion,
            self.serverTimestamp, self.webSocketServerUrl];
}

@end
