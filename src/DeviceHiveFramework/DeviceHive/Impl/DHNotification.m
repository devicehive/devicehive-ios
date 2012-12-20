//
//  DHNotification.m
//  DeviceHiveDevice
//
//  Created by Alex Maydanik on 10/27/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHNotification.h"
#import "DHEntity+SerializationPrivate.h"
#import "NSMutableDictionary+DHEntitySerialization.h"

@implementation DHNotification

- (id)initWithName:(NSString *)name parameters:(NSDictionary *)parameters {
    return [self initWithId:nil name:name timestamp:nil parameters:parameters];
}

- (id)initWithId:(NSString *)notificationID name:(NSString *)name timestamp:(NSString *)timestamp parameters:(NSDictionary *)parameters {
    self = [super init];
    if (self) {
        _notificationID = notificationID;
        _name = name;
        _timestamp = timestamp;
        _parameters = parameters;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
    return [self initWithId:dictionary[@"id"]
                       name:dictionary[@"notification"]
                  timestamp:dictionary[@"timestamp"]
                 parameters:dictionary[@"parameters"]];
}

- (NSDictionary *)classDictionary {
    NSMutableDictionary* resultDict = [NSMutableDictionary dictionary];
    [resultDict setObjectIfNotNull:self.notificationID forKey:@"id"];
    [resultDict setObjectIfNotNull:self.name forKey:@"notification"];
    [resultDict setObjectIfNotNull:self.timestamp forKey:@"timestamp"];
    [resultDict setObjectIfNotNull:self.parameters forKey:@"parameters"];
    return [NSDictionary dictionaryWithDictionary:resultDict];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p, name: %@, notificationID: %@, parameters: %@, timestamp: %@>",
            NSStringFromClass([self class]), self, self.name,
            self.notificationID, self.parameters, self.timestamp];
}


@end
