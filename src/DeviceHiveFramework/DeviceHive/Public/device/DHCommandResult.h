//
//  DHCommandResult.h
//  DeviceHiveFramework
//
//  Created by Maxim Kiselev on 11/08/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHEntity.h"

/**
 Defines command execution status
 */
typedef enum : NSUInteger {
    DHCommandStatusCompleted,
    DHCommandStatusFailed
} DHCommandStatus;

/**
 Represents command execution result which is reported to the server.
 */
@interface DHCommandResult : DHEntity

/**
 Command status, as reported by device or related infrastructure.
 */
@property (nonatomic, readonly) DHCommandStatus status;

/**
 Command execution result. Object with arbitrary structure.
 */
@property (nonatomic, strong, readonly) id result;

/**
 Creates object with status and result.
 @param status Command status.
 @param result Command execution result.
 */
+ (id)commandResultWithStatus:(DHCommandStatus)status
                       result:(id)result;

/**
 Init object with status and result.
 @param status Command status.
 @param result Command execution result.
 */
- (id)initWithStatus:(DHCommandStatus)status
              result:(id)result;

@end
