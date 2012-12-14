//
//  DHCommandResult.m
//  DeviceHiveDevice
//
//  Created by Alex Maydanik on 10/27/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHCommandResult.h"
#import "DHEntity+SerializationPrivate.h"
#import "NSMutableDictionary+DHEntitySerialization.h"

@implementation DHCommandResult

+ (id)commandResultWithStatus:(DHCommandStatus)status result:(NSString*)result {
    return [[[self class] alloc] initWithStatus:status result:result];
}

- (id)initWithStatus:(DHCommandStatus)status result:(NSString*)result {
    self = [super init];
    if (self) {
        _status = status;
        _result = result;
    }
    return self;
}

- (NSDictionary *)classDictionary {
    NSMutableDictionary* resultDict = [NSMutableDictionary dictionary];
    [resultDict setObjectIfNotNull:[self statusAsString] forKey:@"status"];
    [resultDict setObjectIfNotNull:self.result forKey:@"result"];
    return resultDict;
}

- (NSString*)statusAsString {
    switch (self.status) {
        case DHCommandStatusCompleted:
            return @"Completed";
        case DHCommandStatusFailed:
            return @"Failed";
    }
}

- (DHCommandStatus)statusFromString:(NSString*)statusString {
    if ([statusString isEqualToString:@"Completed"]) {
        return DHCommandStatusCompleted;
    } else if ([statusString isEqualToString:@"Failed"]) {
        return DHCommandStatusFailed;
    } else {
        @throw NSInvalidArgumentException;
    }
}

@end
