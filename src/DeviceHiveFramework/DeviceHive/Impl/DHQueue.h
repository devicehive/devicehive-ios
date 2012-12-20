//
//  DHQueue.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/30/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHQueue : NSObject

+ (DHQueue *)queue;

- (void)enqueueObject:(id)object;
- (void)enqueueAllObjects:(NSArray *)objects;
- (id)dequeueObject;
- (NSArray *)dequeueAllObjects;
- (NSUInteger)count;

@end
