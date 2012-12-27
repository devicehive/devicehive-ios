//
//  DHSingleDeviceClient.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 12/24/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHDeviceData.h"
#import "DHDeviceClient.h"

@protocol DHSingleDeviceClientDelegate;

/**
 Class intended to be used as a device client. 
 It is able to send commands and receive notifications from particular device.
 */
@interface DHSingleDeviceClient : DHDeviceClient

/**
 Device data describing device parameters.
 */
@property (nonatomic, strong, readonly) DHDeviceData* deviceData;


/**
 Init device client with given device data and client service.
 @param device DHDeviceData object that contains parameters of target device.
 @param clientService Client service implementation.
 */
- (id)initWithDevice:(DHDeviceData *)device
       clientService:(id<DHClientService>)clientService;

/**
 Send given command to the device.
 @param command DHCommand instance to be sent.
 @param success Success completion block.
 @param failure Failure completion block
 */
- (void)sendCommand:(DHCommand* )command
            success:(DHDeviceClientSuccessCompletionBlock)success
            failure:(DHDeviceClientFailureCompletionBlock)failure;

/**
 Reload device data from the server. Sync current device state with data from the server.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)reloadDeviceDataWithSuccess:(DHDeviceClientSuccessCompletionBlock)success
                            failure:(DHDeviceClientFailureCompletionBlock)failure;

@end

/**
 Single device client delegale.
 */
@protocol DHSingleDeviceClientDelegate <DHDeviceClientDelegate>

@optional

/**
 Called when client receives new notification from the device.
 @param client `DHDeviceClient` instance.
 @param notification DHNotification instance.
 */
- (void)deviceClient:(DHSingleDeviceClient *)client didReceiveNotification:(DHNotification *)notification;

@end
