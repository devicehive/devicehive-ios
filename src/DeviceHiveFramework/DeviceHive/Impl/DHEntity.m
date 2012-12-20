//
//  DHEntity.m
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/8/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHEntity.h"
#import "DHEntity+SerializationPrivate.h"

@implementation DHEntity

+ (NSArray*)fromArrayOfDictionaries:(NSArray*)dictArray {
    NSMutableArray* arrayOfEntities = [NSMutableArray array];
    for (NSDictionary* entityDict in dictArray) {
        [arrayOfEntities addObject:[[[self class] alloc] initWithDictionary:entityDict]];
    }
    return [NSArray arrayWithArray:arrayOfEntities];
}

@end
