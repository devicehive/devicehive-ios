//
//  DHQueue.m
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/30/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHQueue.h"

@interface DHQueue ()

@property (nonatomic, strong) NSMutableArray* queueArray;

@end

@implementation DHQueue

+ (DHQueue*)queue {
    return [[[self class] alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        _queueArray = [NSMutableArray array];
    }
    return self;
}

- (id)dequeueObject {
    if (self.queueArray.count > 0) {
        id object = self.queueArray[0];
        [self.queueArray removeObjectAtIndex:0];
        return object;
    }
    return nil;
}

- (void)enqueueObject:(id)object {
    [self.queueArray addObject:object];
}

- (void)enqueueAllObjects:(NSArray*)objects {
    [self.queueArray addObjectsFromArray:objects];
}

- (NSArray*)dequeueAllObjects {
    NSArray* allObjects = [NSArray arrayWithArray:self.queueArray];
    [self.queueArray removeAllObjects];
    return allObjects;
}

- (NSUInteger)count {
    return self.queueArray.count;
}


@end
