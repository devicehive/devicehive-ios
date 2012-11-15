//
//  DHCommand+Private.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/13/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHCommand.h"

@interface DHCommand (Private)

- (id)initWithName:(NSString*)name
         commandId:(NSNumber*)commandId
        parameters:(NSDictionary*)parameters
            status:(NSString*)status
            result:(NSString*)result
         timestamp:(NSDate*)timestamp
          lifetime:(NSString*)lifetime
             flags:(NSDate*)flags;

+ (NSArray*)commandsFromArrayOfDictionaries:(NSArray*)commandsDictArray;

+ (NSDateFormatter*)defaultTimestampFormatter;

@end
