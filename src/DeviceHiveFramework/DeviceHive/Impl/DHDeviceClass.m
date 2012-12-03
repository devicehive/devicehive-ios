//
//  DHDeviceClass.m
//  DeviceHiveDevice
//
//  Created by Alex Maydanik on 10/27/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHDeviceClass.h"
#import "DHEntity+SerializationPrivate.h"
#import "NSMutableDictionary+DHEntitySerialization.h"

@implementation DHDeviceClass

- (id)initWithName:(NSString *)name version:(NSString *)version {
    return [self initWithName:name version:version offlineTimeout:0 permanent:NO];
}

- (id)initWithName:(NSString *)name version:(NSString *)version offlineTimeout:(NSNumber*)offlineTimeout permanent:(BOOL)permanent {
    self = [super init];
    if (self) {
        _name = name;
        _version = version;
        _offlineTimeout = offlineTimeout;
        _isPermanent = permanent;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
    return [self initWithName:dictionary[@"name"]
                      version:dictionary[@"version"]
               offlineTimeout:dictionary[@"offlineTimeout"]
                    permanent:[dictionary[@"isPermanent"] boolValue]];
}

- (NSDictionary *)classDictionary {
    NSMutableDictionary* resultDict = [NSMutableDictionary dictionary];
    [resultDict setObjectIfNotNull:self.name forKey:@"name"];
    [resultDict setObjectIfNotNull:self.version forKey:@"version"];
    [resultDict setObjectIfNotNull:self.offlineTimeout forKey:@"offlineTimeout"];
    [resultDict setObjectIfNotNull:self.isPermanent ? @"\"true\"" : @"\"false\"" forKey:@"isPermanent"];
    return [NSDictionary dictionaryWithDictionary:resultDict];
}


@end
