//
//  DHDevice.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHCommand.h"
#import "DHCommandResult.h"
#import "DHCommandExecutor.h"
#import "DHDeviceData.h"
#import "DHNetwork.h"
#import "DHDeviceClass.h"
#import "DHNotification.h"
#import "DHDeviceStatusNotification.h"

@protocol DHDeviceService;

/**
 Completion block which is used and invoked if corresponding operation succeeds.
 @param response Response object provided by the server.
 */
typedef void (^DHDeviceSuccessCompletionBlock)(id response);

/**
 Completion block which is used and invoked if corresponding operation fails.
 @param error An instance of NSError describing the error
 */
typedef void (^DHDeviceFailureCompletionBlock)(NSError *error);

/**
 Represents a device, a unit that executes commands and communicates to the server
 */
@interface DHDevice : NSObject<DHCommandExecutor>

/**
 Device data describing serializable device parameters
 */
@property (nonatomic, strong, readonly) DHDeviceData* deviceData;

/**
 Corresponding DHDeviceService object
 */
@property (nonatomic, strong, readonly) id<DHDeviceService> deviceService;

/**
 Indicates whether the device is currently executing commands, i.e. performs poll/receive/execute/update cycle of command execution 
 */
@property (nonatomic, readonly) BOOL isExecutingCommands;

/**
 Indicates whether the device is registeres with device service. Device should be registered in order to receive commands
 */
@property (nonatomic, readonly) BOOL isRegistered;

/**
 Init object with given parameters.
 @param deviceData DHDeviceData instance
 @param deviceService DHDeviceService implementation to be used by the device
 */
- (id)initWithDeviceData:(DHDeviceData*)deviceData
           deviceService:(id<DHDeviceService>)deviceService;

/**
 Perform device registration
 @param success Success completion block
 @param failure Failure completion block
 */
- (void)registerDeviceWithSuccess:(DHDeviceSuccessCompletionBlock)success
                          failure:(DHDeviceFailureCompletionBlock)failure;

/**
 Send notification
 @param notification DHNotification instance to be sent
 @param success Success completion block
 @param failure Failure completion block
 */
- (void)sendNotification:(DHNotification*)notification
                 success:(DHDeviceSuccessCompletionBlock)success
                 failure:(DHDeviceFailureCompletionBlock)failure;

/** Starts/Resumes commands receiving/executing/updating process.
 Override DHCommandExecutor protocol methods in order to be able to handle commands
 */
- (void)beginExecutingCommands;

/** Stops/Pauses commands execution.
 Override DHCommandExecutor protocol methods in order to be able to handle commands
 */
- (void)stopExecutingCommands;

/** @name Callbacks */

/**
 Called just before starting device registration process
 */
- (void)willStartRegistration;

/**
 Called right after device registration is finished
 */
- (void)didFinishRegistration;

/**
 Called if device registration is failed
 @param error An instance of NSError describing the error
 */
- (void)didFailRegistrationWithError:(NSError*)error;

/**
 Called just before device the device will send notification
 @param notification DHNotification instance
 */
- (void)willSendNotification:(DHNotification*)notification;

/**
 Called right after device the device sent notification
 @param notification DHNotification instance
 */
- (void)didSendNotification:(DHNotification*)notification;

/**
 Called if device is failed to send notification
 @param notification DHNotification instance
 @param error An instance of NSError describing the error
 */
- (void)didFailSendNotification:(DHNotification*)notification
                      withError:(NSError*)error;

@end
