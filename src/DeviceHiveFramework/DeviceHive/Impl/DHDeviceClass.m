//
//  DHDeviceClass.m
//  DeviceHiveDevice
//
//  Created by Alex Maydanik on 10/27/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHDeviceClass.h"
#import "DHEntity+SerializationPrivate.h"
#import "NSMutableDictionary+DHEntitySerialization.h"

@implementation DHDeviceClass

- (id)initWithName:(NSString *)name version:(NSString *)version {
    return [self initWithId:nil name:name version:version offlineTimeout:nil permanent:NO];
}

- (id)initWithName:(NSString *)name version:(NSString *)version offlineTimeout:(NSNumber *)offlineTimeout {
    return [self initWithId:nil name:name version:version offlineTimeout:offlineTimeout permanent:NO];
}

- (id)initWithName:(NSString *)name version:(NSString *)version offlineTimeout:(NSNumber *)offlineTimeout permanent:(BOOL)permanent {
    return [self initWithId:nil name:name version:version offlineTimeout:offlineTimeout permanent:permanent];
}

- (id)initWithId:(NSNumber *)deviceClassID
            name:(NSString *)name
         version:(NSString *)version
  offlineTimeout:(NSNumber *)offlineTimeout
       permanent:(BOOL)permanent {
    self = [super init];
    if (self) {
        _deviceClassID = deviceClassID;
        _name = name;
        _version = version;
        _offlineTimeout = offlineTimeout;
        _isPermanent = permanent;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
    DHDeviceClass* deviceClass = [self initWithId:dictionary[@"id"]
                                             name:dictionary[@"name"]
                                          version:dictionary[@"version"]
                                   offlineTimeout:dictionary[@"offlineTimeout"]
                                        permanent:[dictionary[@"isPermanent"] boolValue]];
    deviceClass.data = dictionary[@"data"];
    return deviceClass;
}

- (NSDictionary *)classDictionary {
    NSMutableDictionary* resultDict = [NSMutableDictionary dictionary];
    [resultDict setObjectIfNotNull:self.deviceClassID forKey:@"id"];
    [resultDict setObjectIfNotNull:self.name forKey:@"name"];
    [resultDict setObjectIfNotNull:self.version forKey:@"version"];
    [resultDict setObjectIfNotNull:self.offlineTimeout forKey:@"offlineTimeout"];
    [resultDict setObjectIfNotNull:[NSNumber numberWithBool:self.isPermanent] forKey:@"isPermanent"];
    [resultDict setObjectIfNotNull:self.data forKey:@"data"];
    return [NSDictionary dictionaryWithDictionary:resultDict];
}


@end
