//
//  DHIDeviceService.h
//  DeviceHiveDevice
//
//  Created by Maxim Kiselev on 11/07/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Completion block which is used and invoked in context of device service operation if corresponding operation succeeds.
 @param response Response object provided by the server.
 */
typedef void (^DHDeviceServiceSuccessCompletionBlock)(id response);

/**
 Completion block which is used and invoked in context of device service operation if corresponding operation fails.
 @param error An instance of NSError describing the error
 */
typedef void (^DHDeviceServiceFailureCompletionBlock)(NSError *error);

@class DHDevice, DHNotification, DHCommand;

@class DHCommandResult;

/**
 `DHDeviceService` protocol defines common interface for classes which implement and encapsulate device registration logic, command polling and dispatching mechanism and also posting notifications. Methods of this protocol are not supposed to be called directly. Instead, each device should be initialised with an instance of a class which adopts this protocol.
 */
@protocol DHDeviceService <NSObject>

/** Issues a registration request for the given device.
 @param device DHDevice to be registered
 @param success Success completion block. Response object is a DHDeviceData instance
 @param failure Failure completion block
 */
- (void)registerDevice:(DHDevice*)device
               success:(DHDeviceServiceSuccessCompletionBlock) success
               failure:(DHDeviceServiceFailureCompletionBlock) failure;

/** Sends notification on behalf of the given device.
 @param notification Notification to be sent
 @param device Sender DHDevice object 
 @param success Success completion block. 
 @param failure Failure completion block
 */
- (void)sendNotification:(DHNotification*)notification
               forDevice:(DHDevice*)device
                 success:(DHDeviceServiceSuccessCompletionBlock) success
                 failure:(DHDeviceServiceFailureCompletionBlock) failure;

/** Poll notifications sent from given device starting from given date timestamp. Returns array of DHNotification.
 In the case when no commands were found, the server doesn't return response until a new notification is received. The blocking period is limited.
 @param device DHDevice object which represent target device to receive commands for.
 @param lastCommandPollTimestamp Timestamp of the last received command. If not specified, server timestamp will be used instead.
 @param success Success completion block.
 @param failure Failure completion block
 */
- (void)pollCommandsForDevice:(DHDevice *)device
                        since:(NSString *)lastCommandPollTimestamp
                   completion:(DHDeviceServiceSuccessCompletionBlock)success
                      failure:(DHDeviceServiceFailureCompletionBlock)failure;

/** Update status of given command with given DHCommandResult.
 @param command DHCommand to be updated.
 @param device DHDevice object which represents target device.
 @param result DHCommandResult instance reperesenting command execution result.
 @param success Success completion block.
 @param failure Failure completion block
 */
- (void)updateCommand:(DHCommand*)command
            forDevice:(DHDevice*)device
           withResult:(DHCommandResult*)result
              success:(DHDeviceServiceSuccessCompletionBlock) success
              failure:(DHDeviceServiceFailureCompletionBlock) failure;

@end
