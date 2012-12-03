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

@end

@implementation DHCommandQueue

- (NSUInteger)enqueueAllNotCompleted:(NSArray*)commands {
    NSUInteger enqueuedCommandsCount = 0;
    if (commands && commands.count > 0) {
        for (DHCommand* command in commands) {
            if (!command.status ||
                (id)command.status == [NSNull null] ||
                    command.status.length == 0) {
                [self enqueueObject:command];
                enqueuedCommandsCount++;
            }
        }
    }
    return enqueuedCommandsCount;
}

@end
