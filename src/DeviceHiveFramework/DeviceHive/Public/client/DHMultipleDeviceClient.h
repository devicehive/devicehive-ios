//
//  DHMultipleDeviceClient.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 12/25/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHDeviceClient.h"


/**
 Class intended to be used as a client of multiple devices. 
 It is able to send commands to particular device and receive notifications from all given devices.
 */
@interface DHMultipleDeviceClient : DHDeviceClient

/**
 Array of DHDeviceData describing array of devices and their parameters.
 */
@property (nonatomic, strong, readonly) NSArray* devices;

/**
 Init device client with given array of devices and client service.
 @param devices Array of DHDeviceData objects.
 @param clientService Client service implementation.
 */
- (id)initWithDevices:(NSArray *)devices
        clientService:(id<DHClientService>)clientService;

/**
 Send given command to the given device.
 @param command DHCommand instance to be sent.
 @param device Target device to send command.
 @param success Success completion block.
 @param failure Failure completion block
 */
- (void)sendCommand:(DHCommand *)command
          forDevice:(DHDeviceData *)device
            success:(DHDeviceClientSuccessCompletionBlock)success
            failure:(DHDeviceClientFailureCompletionBlock)failure;

/**
 Reload device data from the server. Sync current device state with data from the server.
 @param deviceData Device data to be reloaded.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)reloadDeviceData:(DHDeviceData *)deviceData
                 success:(DHDeviceClientSuccessCompletionBlock)success
                 failure:(DHDeviceClientFailureCompletionBlock)failure;

@end

/**
 Multiple device client delegale.
 */
@protocol DHMultipleDeviceClientDelegate <DHDeviceClientDelegate>

@optional

/**
 Called when multiple device client receives new notification from one of the device.
 @param client `DHMultipleDeviceClient` instance.
 @param notification DHNotification instance.
 @param deviceData Device-sender of the notification.
 */
- (void)deviceClient:(DHMultipleDeviceClient *)client didReceiveNotification:(DHNotification *)notification fromDeviceWithId:(NSString *)deviceId;

@end
