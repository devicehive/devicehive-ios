//
//  NSMutableDictionary+DHEntitySerialization.m
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/8/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "NSMutableDictionary+DHEntitySerialization.h"

@implementation NSMutableDictionary (DHEntitySerialization)

- (void)setObjectIfNotNull:(id)anObject forKey:(id <NSCopying>)aKey {
    if (anObject && anObject != [NSNull null]) {
        [self setObject:anObject forKey:aKey];
    }
}

@end
