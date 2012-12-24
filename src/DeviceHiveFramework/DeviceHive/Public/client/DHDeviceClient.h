//
//  DHDeviceClient.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/30/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHDeviceData.h"
#import "DHClientService.h"
#import "DHNotification.h"

@protocol DHDeviceClientDelegate;

/**
 Completion block which is used and invoked if corresponding operation succeeds.
 @param response Response object provided by the server.
 */
typedef void (^DHDeviceClientSuccessCompletionBlock)(id response);

/**
 Completion block which is used and invoked if corresponding operation fails.
 @param error An instance of NSError describing the error.
 */
typedef void (^DHDeviceClientFailureCompletionBlock)(NSError *error);


/**
 Class intended to be used as a device client. 
 It is able to send commands and receive notifications from particular device.
 */
@interface DHDeviceClient : NSObject

/**
 Corresponding DHClientService object.
 */
@property (nonatomic, strong, readonly) id<DHClientService> clientService;

/**
 Indicates whether the client is currently handling notifications.
 */
@property (nonatomic, readonly) BOOL isReceivingNotifications;

/**
 The date when last notifications poll request was sent to the server(timestamp of the last received notification).
 This value is used as a starting point in time from which every subsequent notifications (which was posted after this point) will be received by the client. If not initialized, server's timestamp will be used instead.
 Clients are suppose to persist the last poll date somewhere(e.g. NSUserDefaults) and restore it when the app relaunched in order to avoid receiving obsolete notifications.
 */
@property (nonatomic, strong) NSString* lastNotificationPollTimestamp;

/**
 Device client delegate.
 */
@property (nonatomic, weak) id<DHDeviceClientDelegate> delegate;


- (id)initWithClientService:(id<DHClientService>)clientService;

/** Starts/Resumes notifications handling.
 Override method in order to be able to receive notifications.
 */
- (void)beginReceivingNotifications;

/** Stops/Pauses notifications handling.
Override method in order to be able to receive notifications.
 */
- (void)stopReceivingNotifications;

@end

/**
 Device client delegale.
 */
@protocol DHDeviceClientDelegate <NSObject>

@optional

/**
 Called when client is about to start receiving notifications.
 @param client `DHDeviceClient` instance.
 */
- (void)deviceClientWillBeginReceivingNotifications:(DHDeviceClient *)client;

/**
 Called when device has just stopped receiving notifications.
 @param client `DHDeviceClient` instance.
 */
- (void)deviceClientDidStopReceivingNotifications:(DHDeviceClient *)client;

/**
 Called just before client sends command to the device.
 @param client `DHDeviceClient` instance.
 @param command DHCommand instance.
 */
- (void)deviceClient:(DHDeviceClient *)client willSendCommand:(DHCommand *)command;

/**
 Called right after client has sent command.
 @param client `DHDeviceClient` instance.
 @param command DHCommand instance.
 */
- (void)deviceClient:(DHDeviceClient *)client didSendCommand:(DHCommand *)command;

/**
 Called if client is failed to send command to the device.
 @param client `DHDeviceClient` instance.
 @param command DHCommand instance.
 @param error An instance of NSError describing the error.
 */
- (void)deviceClient:(DHDeviceClient *)client didFailSendCommand:(DHCommand *)command withError:(NSError *)error;



@end
