//
//  DHCommand+Private.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/13/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHCommand.h"

@interface DHCommand (Private)

- (id)initWithName:(NSString*)name
         commandId:(NSNumber*)commandId
        parameters:(NSDictionary*)parameters
            status:(NSString*)status
            result:(id)result
         timestamp:(NSString*)timestamp
          lifetime:(NSNumber*)lifetime
             flags:(NSNumber*)flags;

+ (NSDateFormatter*)defaultTimestampFormatter;

@end
