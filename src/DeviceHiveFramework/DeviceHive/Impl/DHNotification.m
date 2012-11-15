//
//  DHNotification.m
//  DeviceHiveDevice
//
//  Created by Alex Maydanik on 10/27/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHNotification.h"
#import "DHEntity+SerializationPrivate.h"
#import "NSMutableDictionary+DHEntitySerialization.h"

@implementation DHNotification

- (id)initWithName:(NSString *)name parameters:(NSDictionary *)parameters {
    self = [super init];
    if (self) {
        _name = name;
        _parameters = parameters;
    }
    return self;
 }

- (NSDictionary *)classDictionary {
    NSMutableDictionary* resultDict = [NSMutableDictionary dictionary];
    [resultDict setObjectIfNotNull:self.name forKey:@"notification"];
    [resultDict setObjectIfNotNull:self.parameters forKey:@"parameters"];
    return [NSDictionary dictionaryWithDictionary:resultDict];
}

@end
