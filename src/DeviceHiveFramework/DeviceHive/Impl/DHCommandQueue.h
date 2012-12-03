//
//  DHCommandQueue.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHQueue.h"

@class DHCommand;

@interface DHCommandQueue : DHQueue

- (NSUInteger)enqueueAllNotCompleted:(NSArray*)commands;

@end
