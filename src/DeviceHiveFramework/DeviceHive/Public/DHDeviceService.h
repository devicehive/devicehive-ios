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
 `DHDeviceService` protocol defines common interface for classes which implement and encapsulate device registration logic, command polling and dispatching mechanism and also posting notifications.
 */
@protocol DHDeviceService <NSObject>

/**
 The date when last commands poll request was sent to the server(timestamp of the last received command).
 This value is used as a starting point in time from which every subsequent command (which was posted after this point) will be received and executed by the device. If not initialized, *ALL* existing commands will be received along with the first poll response.
 Clients are suppose to persist the last poll date somewhere(e.g. NSUserDefaults) and restore it when the app relaunched in order to avoid receiving already executed commands.
 */
@property (nonatomic, strong) NSDate* lastCommandPollTimestamp;

/**
 Minimum time (in seconds) between two poll command requests. 
 Implementers may set reasomable default value of this property (e.g. 3 seconds)
 */
@property (nonatomic) NSTimeInterval minimumCommandPollInterval;

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

/** Starts/Resumes commands receiving/executing/updating process for the given device.
 @param device DHDevice which will receive and execute commands. DHDevice should be registered with the service before executing any commands
 */
- (void)beginExecutingCommandsForDevice:(DHDevice*)device;

/** Stops/pauses commands receiving/executing/updating process for the given device.
 @param device DHDevice which should stop command processing
 */
- (void)stopExecutingCommandsForDevice:(DHDevice*)device;

@end
