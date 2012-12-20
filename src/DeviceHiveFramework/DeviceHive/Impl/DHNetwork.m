//
//  DHNetwork.m
//  DeviceHiveDevice
//
//  Created by Alex Maydanik on 10/27/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHNetwork.h"
#import "DHEntity+SerializationPrivate.h"
#import "NSMutableDictionary+DHEntitySerialization.h"

@implementation DHNetwork

- (id)initWithName:(NSString *)name description:(NSString *)description {
    return [self initWithName:name description:description key:nil];
}

- (id)initWithName:(NSString *)name description:(NSString *)description key:(NSString *)key {
    return [self initWithName:name networkId:nil description:description key:nil];
}

- (id)initWithName:(NSString *)name networkId:(NSString*)networkId description:(NSString *)description key:(NSString *)key {
    self = [super init];
    if (self) {
        _networkID = networkId;
        _name = name;
        _description = description;
        _key = key;
    }
    return self;
}

- (NSDictionary *)classDictionary {
    NSMutableDictionary* resultDict = [NSMutableDictionary dictionary];
    [resultDict setObjectIfNotNull:self.networkID forKey:@"id"];
    [resultDict setObjectIfNotNull:self.key forKey:@"key"];
    [resultDict setObjectIfNotNull:self.name forKey:@"name"];
    [resultDict setObjectIfNotNull:self.description forKey:@"description"];
    [resultDict setObjectIfNotNull:self.networkID forKey:@"id"];
    return [NSDictionary dictionaryWithDictionary:resultDict];
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
    return [self initWithName:dictionary[@"name"]
                    networkId:dictionary[@"id"]
                  description:dictionary[@"description"]
                          key:dictionary[@"key"]];
}

@end
