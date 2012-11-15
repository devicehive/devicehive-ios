//
//  DHCommandQueue.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHCommand;

@interface DHCommandQueue : NSObject

+ (DHCommandQueue*)commandQueue;

- (void)enqueue:(DHCommand*)command;
- (NSUInteger)enqueueAllNotCompleted:(NSArray*)commands;
- (void)enqueueAll:(NSArray*)commands;
- (DHCommand*)dequeue;
- (NSArray*)dequeueAll;

@end
