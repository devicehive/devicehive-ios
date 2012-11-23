//
//  DHCommand.m
//  DeviceHiveDevice
//
//  Created by Alex Maydanik on 10/27/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHCommand.h"
#import "DHEntity+SerializationPrivate.h"
#import "NSMutableDictionary+DHEntitySerialization.h"
#import "DHCommand+Private.h"

static NSDateFormatter* defaultDateFormatter = nil;

@implementation DHCommand

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultDateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [defaultDateFormatter setTimeZone:gmt];
        [defaultDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.'SSSSSS"];
    });
}

- (id)initWithName:(NSString*)name
         commandId:(NSNumber*)commandId
        parameters:(NSDictionary*)parameters
            status:(NSString*)status
            result:(NSString*)result
         timestamp:(NSString*)timestamp
          lifetime:(NSNumber*)lifetime
             flags:(NSNumber*)flags {
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

+ (NSArray*)commandsFromArrayOfDictionaries:(NSArray*)commandsDictArray {
    NSMutableArray* arrayOfCommands = [NSMutableArray array];
    for (NSDictionary* commandDict in commandsDictArray) {
        [arrayOfCommands addObject:[[DHCommand alloc] initWithDictionary:commandDict]];
    }
    return [NSArray arrayWithArray:arrayOfCommands];
}

+ (NSDateFormatter*)defaultTimestampFormatter {
    return defaultDateFormatter;
}

- (NSString*)description {
	return [NSString stringWithFormat:@"<%@: %p, name: %@, commandID: %@, parameters: %@, status: %@, result: %@, timestamp: %@, lifetime: %@, flags: %@>",
            NSStringFromClass([self class]), self, self.name,
            self.commandID, self.parameters, self.status, self.result,
            self.timeStamp, self.lifetime, self.flags];
}

@end
