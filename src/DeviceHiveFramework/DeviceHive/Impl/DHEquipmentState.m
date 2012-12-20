//
//  DHEquipmentState.m
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/30/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHEquipmentState.h"
#import "DHEntity+SerializationPrivate.h"

@implementation DHEquipmentState

- (id)initWithEquipmentCode:(NSString *)code
                  timestamp:(NSString *)timestamp
                 parameters:(NSDictionary *)parameters {
    self = [super init];
    if (self) {
        _code = code;
        _timestamp = timestamp;
        _parameters = parameters;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    return [self initWithEquipmentCode:dictionary[@"id"]
                             timestamp:dictionary[@"timestamp"]
                            parameters:dictionary[@"parameters"]];
}

@end
