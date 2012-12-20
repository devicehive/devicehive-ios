//
//  DHCommandResult.h
//  DeviceHiveDevice
//
//  Created by Maxim Kiselev on 11/08/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
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
 Command execution result.
 */
@property (nonatomic, strong, readonly) NSString* result;

/**
 Creates object with status and result.
 @param status Command status.
 @param result Command execution result.
 */
+ (id)commandResultWithStatus:(DHCommandStatus)status
                       result:(NSString*)result;

/**
 Init object with status and result.
 @param status Command status.
 @param result Command execution result.
 */
- (id)initWithStatus:(DHCommandStatus)status
              result:(NSString*)result;

@end
