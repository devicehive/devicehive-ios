//
//  DHClientService.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/30/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHService.h"

@class DHNetwork;
@class DHDeviceClass;
@class DHDeviceData;
@class DHCommand;

/**
 `DHClientService` protocol defines common interface for classes which implement and encapsulate generic Device Hive Client-related functionality, such as retrieving a list of networks available to the client, retrieving devices which belong to given network, polling/getting notifications. 
 */
@protocol DHClientService <DHService>

/** Get a list of networks available for current client. As a result this method returns an array of DHNetwork objects.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)getNetworksWithCompletion:(DHServiceSuccessCompletionBlock)success
                          failure:(DHServiceFailureCompletionBlock)failure;

/** Get a list of device which belong to given network. As a result this method returns an array of DHDeviceData objects.
 @param network DHNetwork object which represent network.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)getDevicesOfNetwork:(DHNetwork *)network
                 completion:(DHServiceSuccessCompletionBlock)success
                    failure:(DHServiceFailureCompletionBlock)failure;

/** Get a device data with given device identifier. As a result this method returns DHDeviceData object.
 @param deviceId Device identifier.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)getDeviceWithId:(NSString *)deviceId
             completion:(DHServiceSuccessCompletionBlock)success
                failure:(DHServiceFailureCompletionBlock)failure;

/** Get a list of equipment for given device class. As a result this method returns an array of DHEquipmentData objects.
 @param deviceClass DHDeviceClass object which represent device class.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)getEquipmentOfDeviceClass:(DHDeviceClass *)deviceClass
                       completion:(DHServiceSuccessCompletionBlock)success
                          failure:(DHServiceFailureCompletionBlock)failure;

/** Poll notifications sent from given device starting from given date timestamp. Returns array of DHNotification.
 In the case when no notifications were found, the server doesn't return response until new notification is received. The blocking period is limited.
 @param device DHDeviceData object which represent target device to receive notifications from.
 @param lastNotificationPollTimestamp Timestamp of the last received notification from the device. If not specified, server timestamp will be used instead.
 @param waitTimeout Waiting timeout in seconds (default: 30 seconds, maximum: 60 seconds). Specify 0 to disable waiting.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)pollDeviceNotifications:(DHDeviceData *)device
                          since:(NSString *)lastNotificationPollTimestamp
                    waitTimeout:(NSNumber *)waitTimeout
                     completion:(DHServiceSuccessCompletionBlock)success
                        failure:(DHServiceFailureCompletionBlock)failure;

/** Poll notifications sent from given devices starting from given date timestamp. Returns an array of following structure [{"deviceId":deviceId1, "notification" : DHNotification}, {"deviceId":deviceId2, "notification" : DHNotification}].
 In the case when no notifications were found, the server doesn't return response until new notification is received. The blocking period is limited.
 @param devices Array of DHDeviceData objects which represents devices to receive notifications from.
 @param lastNotificationPollTimestamp Timestamp of the last received notification from the device. If not specified, server timestamp will be used instead.
 @param waitTimeout Waiting timeout in seconds (default: 30 seconds, maximum: 60 seconds). Specify 0 to disable waiting.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)pollDevicesNotifications:(NSArray *)devices
                           since:(NSString *)lastNotificationPollTimestamp
                     waitTimeout:(NSNumber *)waitTimeout
                      completion:(DHServiceSuccessCompletionBlock)success
                         failure:(DHServiceFailureCompletionBlock)failure;

/** Get notifications sent from given device starting from given date timestamp. Returns array of DHNotification.
 The server returns results immediately regardless of whether any notifications were sent from the device since given date.
 @param device DHDeviceData object which represent target device to receive notifications from.
 @param lastNotificationPollTimestamp Timestamp of the last received notification from the device. If not specified, server timestamp will be used instead.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)getDeviceNotifications:(DHDeviceData *)device
                         since:(NSString *)lastNotificationPollTimestamp
                    completion:(DHServiceSuccessCompletionBlock)success
                       failure:(DHServiceFailureCompletionBlock)failure;

/** Send command to given device. As a result returns DHCommand returned by the server as a response.
 @param command DHCommand to be sent.
 @param device DHDevice object which represents recipient device.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)sendCommand:(DHCommand *)command
          forDevice:(DHDeviceData *)device
         completion:(DHServiceSuccessCompletionBlock)success
            failure:(DHServiceFailureCompletionBlock)failure;

/** Get equipment state for given device. Returns array of DHEquipmentState objects describing current state of device equipment.
 @param device DHDevice object which represents recipient device.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)getEquipmentStateOfDevice:(DHDeviceData *)device
                       completion:(DHServiceSuccessCompletionBlock)success
                          failure:(DHServiceFailureCompletionBlock)failure;

/** Get command sent to given device. Returns DHCommand object retrieved from the server with current status and result.
 @param commandId Command identifier.
 @param device DHDevice object which represents a device.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)getCommandWithId:(NSNumber *)commandId
            sentToDevice:(DHDeviceData *)device
              completion:(DHServiceSuccessCompletionBlock)success
                 failure:(DHServiceFailureCompletionBlock)failure;

@end
