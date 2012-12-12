//
//  EMRESTClient.h
//  EmbeddedControl
//
//  Created by  on 11.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFHTTPClient.h"

@class EMNetworkMO;
@class EMDeviceMO;
@class EMDeviceClassMO;
@class EMPersistentStorageManager;
@class EMBaseServiceRequest;

/**
 Request completion block type definition
 */
typedef void (^RequestCompletionBlock)();

/**
 Request failure block - returns an instance of NSError class which provides the information about failure reason
 @param error An instance of NSError
 */
typedef void (^RequestFailureBlock)(NSError *error);

/**
 Long polling completion block
 @param continuePolling An address of boolean variable specifying whether long polling should be continued.
 @param error A reference to an error object if there are any troubles with long poll, nil otherwise
 */
typedef void (^PollRequestCompletionBlock)(BOOL *continuePolling, NSError *error);

/**
 `EMRESTClient` encapsulates client-server communications for DeviceHive iOS clients. It is designed to hide the guts of network operations and content parsing from its end users. This class is derived from `AFHTTPClient` which is a part of AFNetworking library.
 
 ## Registering requests
 
 If there is a need to extend existing client application's behavior, please provide additional requests registered in `EMRESTClient`'s `initWithBaseURL:` method. Each request subclass should override class method named `canProcessRequest:` to help the REST client instance to determine whether a specified URL should be handled by an instance of request class.
 
 ## Adding own methods
 
 To add an individual REST API call, please create appropriate subclass of `EMBaseServiceRequest` first and a new method which calls `requestPath:method:parameters:configurationBlock:success:failure:` internally. Here,
 
  - `requestPath` stands for URL which is relative to base service URL passed in `initWithBaseURL:`;
  - `method` is one of allowed HTTP methods (GET/POST/PUT/DELETE);
  - `parameters` is an instance of NSDictionary which provides request parameters to be serialized as JSON message for POST/PUT and as URL string for GET request;
  - `configurationBlock` pushes a newly created instance of `EMBaseServiceRequest`'s concrete subclass to be configured;
  - `success` and `failure` are callback blocks for request's successful and erroneous completion, respectively.
 */

@interface EMRESTClient : AFHTTPClient

/**
 Provides a link to application's persistent storage manager
 */
@property (nonatomic, strong, readonly) EMPersistentStorageManager *persistentStorageManager;

/** Performs a call to the server to provide all available networks for current user and synchronize them with the networks cached on the device.
 
 When a list of available networks is received, the underlying request parses it in the background. It attempts to fetch local copies of networks by their IDs. Those networks which were not presented in server's response are deleted from local database with their child devices

 @param success Completion block invocated on successful request finish
 @param failure Completion block invocated on request's failure
 */
- (void) getNetworkList:(RequestCompletionBlock)success failure:(RequestFailureBlock)failure;

/** Performs a call to the server to provide all available devices for the specified network and synchronize them with the network's devices cached locally.
 
 This method and its underlying request uses the same parsing mechanism as `getNetworkList:failure:` does. Additionally, request attempts to match devices with the existing classes, if possible.

 @param network An instance of CoreData's class `EMNetworkMO` specifying devices for which network should be retrieved
 @param success Completion block invocated on successful request finish
 @param failure Completion block invocated on request's failure
 */
- (void) getDeviceListFromNetwork:(EMNetworkMO*)network
                          success:(RequestCompletionBlock)success failure:(RequestFailureBlock)failure;

/** Performs a call to the server to update local copy of device class and its children - equipment items.
 
 If device class is not found in the local storage,
 
 @param deviceClass Device class which should be updated
 @param success Completion block invocated on successful request finish
 @param failure Completion block invocated on request's failure
 */
- (void) updateDeviceClass:(EMDeviceClassMO*)deviceClass success:(RequestCompletionBlock)success failure:(RequestFailureBlock)failure;

/** Upates the specified device's state by updating its class information and retrieving device's notifications from the server
 
 This method combines 'updateDeviceClass:success:failure' and 'getDeviceNotifications:success:failure:' methods inside. 
 
 @param device Device which state should be updated
 @param success Completion block invocated on successful request finish
 @param failure Completion block invocated on request's failure
 */
- (void) updateDeviceState:(EMDeviceMO*)device success:(RequestCompletionBlock)success failure:(RequestFailureBlock)failure;

/** Tries to retrieve all device's notifications for the last 2 hours.
  
 @param device Device for which the notification list should be retrieved
 @param success Completion block invocated on successful request finish
 @param failure Completion block invocated on request's failure
 */
- (void) getDeviceNotifications:(EMDeviceMO*)device success:(RequestCompletionBlock)success failure:(RequestFailureBlock)failure;

/** Performs long polling to find if there are any new events assigned to the device.
 
 If there are no notifications for the device and no events happen during 20 seconds, the server returns an empty response. The device can be polled until a certain UI event is triggered (i.e., user leaves device details screen)
 
 @param device Device which state should be updated
 @param completionBlock Completion block which returns current error in case there are some troubles with the polling. The first parameter allows to specify whether REST client should continue long polling.
 */
- (void) deviceLongPoll:(EMDeviceMO*)device completionBlock:(PollRequestCompletionBlock)completionBlock;

/** Sends a new command to the specified device

 If command is executed successfully, a notification should arrive via long polling mechanism.
 
 @param command Command which device should handle
 @param device Device which state should be updated
 @param equipmentCode Device's equipment state of which should be updated
 @param value New equipment's state
 @param success Completion block invocated on successful request finish
 @param failure Completion block invocated on request's failure
 */
- (void) sendCommand:(NSString*)command toDevice:(EMDeviceMO*)device
       equimpentCode:(NSString*)equipmentCode value:(NSString*)value 
             success:(RequestCompletionBlock)success failure:(RequestFailureBlock)failure;

/** Stops further request processing by suspendind client's operation queue and cancelling enqueued operations.
 
 This method should be invocated when the application is running in the background and all requests have finished. Otherwise, the app should let the requests run intil they're finished using `UIApplication`'s method `beginBackgroundTaskWithExpirationHandler:`
 */
- (void)stopProcessing;
@end
