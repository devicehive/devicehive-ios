//
//  DHCommand.m
//  DeviceHiveFramework
//
//  Created by Maxim Kiselev on 10/27/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHCommand.h"
#import "DHEntity+SerializationPrivate.h"
#import "NSMutableDictionary+DHEntitySerialization.h"
#import "DHCommand+Private.h"

@implementation DHCommand

- (id)initWithName:(NSString *)name
         commandId:(NSNumber *)commandId
        parameters:(id)parameters
            status:(NSString *)status
            result:(id)result
         timestamp:(NSString *)timestamp
          lifetime:(NSNumber *)lifetime
             flags:(NSNumber *)flags {
    self = [super init];
    if (self) {
        _name = name;
        _commandID = commandId;
        _parameters = parameters;
        _status = status;
        _result = result;
        _timeStamp = timestamp;
        _lifetime = lifetime;
        _flags = flags;
    }
    return self;
    
}

- (id)initWithName:(NSString *)name
        parameters:(id)parameters {
    return [self initWithName:name parameters:parameters lifetime:nil flags:nil];
}

- (id)initWithName:(NSString *)name
        parameters:(NSDictionary *)parameters
          lifetime:(NSNumber *)lifetime
             flags:(NSNumber *)flags {
    return [self initWithName:name commandId:nil parameters:parameters status:nil result:nil timestamp:nil lifetime:lifetime flags:flags];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    return [self initWithName:dictionary[@"command"]
                    commandId:dictionary[@"id"]
                   parameters:dictionary[@"parameters"]
                       status:dictionary[@"status"]
                       result:dictionary[@"result"]
                    timestamp:dictionary[@"timestamp"]
                     lifetime:dictionary[@"lifetime"]
                        flags:dictionary[@"flags"]];
}

- (NSDictionary*)classDictionary {
    NSMutableDictionary* resultDict = [NSMutableDictionary dictionary];
    [resultDict setObjectIfNotNull:self.name forKey:@"command"];
    [resultDict setObjectIfNotNull:self.commandID forKey:@"id"];
    [resultDict setObjectIfNotNull:self.parameters forKey:@"parameters"];
    [resultDict setObjectIfNotNull:self.result forKey:@"result"];
    [resultDict setObjectIfNotNull:self.status forKey:@"status"];
    [resultDict setObjectIfNotNull:self.lifetime forKey:@"lifetime"];
    [resultDict setObjectIfNotNull:self.flags forKey:@"flags"];
    [resultDict setObjectIfNotNull:self.timeStamp forKey:@"timestamp"];
    return [NSDictionary dictionaryWithDictionary:resultDict];
}

- (NSString*)description {
	return [NSString stringWithFormat:@"<%@: %p, name: %@, commandID: %@, parameters: %@, status: %@, result: %@, timestamp: %@, lifetime: %@, flags: %@>",
            NSStringFromClass([self class]), self, self.name,
            self.commandID, self.parameters, self.status, self.result,
            self.timeStamp, self.lifetime, self.flags];
}

@end
