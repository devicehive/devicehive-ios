//
//  DHCommandQueue.m
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHCommandQueue.h"
#import "DHCommand.h"

@interface DHCommandQueue ()

@property (nonatomic, strong) NSMutableArray* queueArray;

@end

@implementation DHCommandQueue

+ (DHCommandQueue*)commandQueue {
    return [[[self class] alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        _queueArray = [NSMutableArray array];
    }
    return self;
}

- (DHCommand*)dequeue {
    if (self.queueArray.count > 0) {
        DHCommand* command = self.queueArray[0];
        [self.queueArray removeObjectAtIndex:0];
        return command;
    }
    return nil;
}

- (void)enqueue:(DHCommand*)command {
    [self.queueArray addObject:command];
}

- (void)enqueueAll:(NSArray*)commands {
    [self.queueArray addObjectsFromArray:commands];
}

- (NSUInteger)enqueueAllNotCompleted:(NSArray*)commands {
    NSUInteger enqueuedCommandsCount = 0;
    if (commands && commands.count > 0) {
        for (DHCommand* command in commands) {
            if (!command.status ||
                (id)command.status == [NSNull null] ||
                    command.status.length == 0) {
                [self .queueArray addObject:command];
                enqueuedCommandsCount++;
            }
        }
    }
    return enqueuedCommandsCount;
}

- (NSArray*)dequeueAll {
    NSArray* allCommands = [NSArray arrayWithArray:self.queueArray];
    [self.queueArray removeAllObjects];
    return allCommands;
}

@end
