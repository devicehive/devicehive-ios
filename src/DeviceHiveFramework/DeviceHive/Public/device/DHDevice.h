//
//  DHDevice.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
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
 @param error An instance of NSError describing the error.
 */
typedef void (^DHDeviceFailureCompletionBlock)(NSError *error);

/**
 Represents a device, a unit that executes commands and communicates to the server.
 */
@interface DHDevice : NSObject<DHCommandExecutor>

/**
 Device data describing serializable device parameters.
 */
@property (nonatomic, strong, readonly) DHDeviceData* deviceData;

/**
 Corresponding DHDeviceService object.
 */
@property (nonatomic, strong, readonly) id<DHDeviceService> deviceService;

/**
 Indicates whether the device is currently processing commands, i.e. performs poll/receive/execute/update cycle of command execution.
 */
@property (nonatomic, readonly) BOOL isProcessingCommands;

/**
 Indicates whether the device is registeres with device service. Device should be registered in order to receive commands.
 */
@property (nonatomic, readonly) BOOL isRegistered;

/**
 The date when last commands poll request was sent to the server(timestamp of the last received command).
 This value is used as a starting point in time from which every subsequent command (which was posted after this point) will be received and executed by the device. If not initialized, *ALL* existing commands will be received along with the first poll response.
 Clients are suppose to persist the last poll date somewhere(e.g. NSUserDefaults) and restore it when the app is relaunched in order to avoid receiving already executed commands.
 */
@property (nonatomic, strong) NSString* lastCommandPollTimestamp;

/**
 Init object with given device data.
 @param deviceData DHDeviceData instance.
 */
- (id)initWithDeviceData:(DHDeviceData*)deviceData;

/**
 Perform device registration with given device service.
@param deviceService DHDeviceService implementation to be used by the device.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)registerDeviceWithDeviceService:(id<DHDeviceService>)deviceService
                                success:(DHDeviceSuccessCompletionBlock)success
                                failure:(DHDeviceFailureCompletionBlock)failure;

/**
 Perform device unregistration. 
 This method stops command processing and resets device to the state it was before registration.
 */
- (void)unregisterDevice;

/**
 Send notification.
 @param notification DHNotification instance to be sent.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)sendNotification:(DHNotification*)notification
                 success:(DHDeviceSuccessCompletionBlock)success
                 failure:(DHDeviceFailureCompletionBlock)failure;

/**
 Reload device data from the server. Sync current device state with the data from the server.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)reloadDeviceDataWithSuccess:(DHDeviceSuccessCompletionBlock)success
                            failure:(DHDeviceFailureCompletionBlock)failure;

/** Starts/Resumes commands receiving/executing/updating process.
 Override DHCommandExecutor protocol methods in order to be able to handle commands.
 */
- (void)beginProcessingCommands;

/** Stops/Pauses commands execution.
 Override DHCommandExecutor protocol methods in order to be able to handle commands.
 */
- (void)stopProcessingCommands;

/** @name Callbacks */

/**
 Called just before starting device registration process.
 */
- (void)willStartRegistration;

/**
 Called right after device registration is finished.
 */
- (void)didFinishRegistration;

/**
 Called if device registration is failed
 @param error An instance of NSError describing the error.
 */
- (void)didFailRegistrationWithError:(NSError*)error;

/** 
 Called when device is about to start processing commands.
 */
- (void)willBeginProcessingCommands;

/**
 Called when device has just stopped processing commands.
 */
- (void)didStopProcessingCommands;

/**
 Called just before the device will send notification.
 @param notification DHNotification instance.
 */
- (void)willSendNotification:(DHNotification*)notification;

/**
 Called right after the device sent notification.
 @param notification DHNotification instance.
 */
- (void)didSendNotification:(DHNotification*)notification;

/**
 Called if device is failed to send notification.
 @param notification DHNotification instance.
 @param error An instance of NSError describing the error.
 */
- (void)didFailSendNotification:(DHNotification*)notification
                      withError:(NSError*)error;

/**
 Called just before the device will start unregistration process.
 */
- (void)willUnregister;

/**
 Called when device has just finished unregistration.
 */
- (void)didUnregister;

@end
