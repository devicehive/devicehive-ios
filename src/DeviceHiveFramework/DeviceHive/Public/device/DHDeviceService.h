//
//  DHDeviceService.h
//  DeviceHiveFramework
//
//  Created by Maxim Kiselev on 11/07/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Completion block which is used and invoked in context of device service operation if corresponding operation succeeds.
 @param response Response object provided by the server.
 */
typedef void (^DHDeviceServiceSuccessCompletionBlock)(id response);

/**
 Completion block which is used and invoked in context of device service operation if corresponding operation fails.
 @param error An instance of NSError describing the error.
 */
typedef void (^DHDeviceServiceFailureCompletionBlock)(NSError *error);

@class DHDeviceData, DHNotification, DHCommand;

@class DHCommandResult;

/**
 `DHDeviceService` protocol defines common interface for classes which implement and encapsulate device registration logic, command polling and dispatching mechanism and also posting notifications. Methods of this protocol are not supposed to be called directly. Instead, each device should be initialised with an instance of a class which adopts this protocol.
 */
@protocol DHDeviceService <NSObject>

/** Issues a registration request for the given device.
 @param device DHDeviceData to be registered.
 @param success Success completion block. Response object is a DHDeviceData instance.
 @param failure Failure completion block.
 */
- (void)registerDevice:(DHDeviceData *)device
               success:(DHDeviceServiceSuccessCompletionBlock) success
               failure:(DHDeviceServiceFailureCompletionBlock) failure;


/** Retrieve device data form the server for given device. As a result this method returns DHDeviceData object.
 @param device DHDeviceData object describing current device.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)getDeviceData:(DHDeviceData *)device
           completion:(DHDeviceServiceSuccessCompletionBlock)success
              failure:(DHDeviceServiceFailureCompletionBlock)failure;

/** Sends notification on behalf of the given device.
 @param notification Notification to be sent.
 @param device Sender DHDeviceData object. 
 @param success Success completion block. 
 @param failure Failure completion block
 */
- (void)sendNotification:(DHNotification *)notification
               forDevice:(DHDeviceData *)device
                 success:(DHDeviceServiceSuccessCompletionBlock) success
                 failure:(DHDeviceServiceFailureCompletionBlock) failure;

/** Poll for commands for given device starting from given date timestamp. Returns an array of DHCommand.
 In the case when no commands were found, the server doesn't return response until a new command is received. The blocking period is limited.
 @param device DHDeviceData object which represent target device to receive commands for.
 @param lastCommandPollTimestamp Timestamp of the last received command. If not specified, server timestamp will be used instead.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)pollCommandsForDevice:(DHDeviceData *)device
                        since:(NSString *)lastCommandPollTimestamp
                   completion:(DHDeviceServiceSuccessCompletionBlock)success
                      failure:(DHDeviceServiceFailureCompletionBlock)failure;

/** Update status of given command with given DHCommandResult.
 @param command DHCommand to be updated.
 @param device DHDeviceData object which represents target device.
 @param result DHCommandResult instance reperesenting command execution result.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)updateCommand:(DHCommand *)command
            forDevice:(DHDeviceData *)device
           withResult:(DHCommandResult *)result
              success:(DHDeviceServiceSuccessCompletionBlock) success
              failure:(DHDeviceServiceFailureCompletionBlock) failure;

/**
 Cancel all queued requests.
 */
- (void)cancelAllServiceRequests;

@end
