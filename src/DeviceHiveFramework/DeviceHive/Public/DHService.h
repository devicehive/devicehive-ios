//
//  DHService.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 1/10/13.
//  Copyright (c) 2013 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Completion block which is used and invoked in context of the service operation if this operation succeeds.
 @param response Response object provided by the server.
 */
typedef void (^DHServiceSuccessCompletionBlock)(id response);

/**
 Completion block which is used and invoked in context of the service operation if this operation fails.
 @param error An instance of NSError describing the error.
 */
typedef void (^DHServiceFailureCompletionBlock)(NSError *error);

/**
 `DHService` protocol defines common interface for Device Hive services: client and device.
 */
@protocol DHService <NSObject>

/**
 Get meta-information of the current API. Returns `DHApiInfo` instance as a result.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)getApiInfoWithSuccess:(DHServiceSuccessCompletionBlock)success
                      failure:(DHServiceFailureCompletionBlock)failure;

/**
 Cancel all queued requests.
 */
- (void)cancelAllServiceRequests;

@end
