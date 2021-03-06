//
//  NSMutableDictionary+DHEntitySerialization.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/8/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (DHEntitySerialization)
- (void)setObjectIfNotNull:(id)anObject forKey:(id <NSCopying>)aKey;
@end
