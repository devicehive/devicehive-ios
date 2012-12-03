//
//  DHDeviceApi.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 10/15/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

/**
 Completion block which is invoked if corresponding operation succeeds.
 @param response Response object provided by the server.
 */
typedef void (^DHRestfulApiSuccessCompletionBlock)(id response);

/**
 Completion block which is invoked if corresponding operation fails.
 @param error An instance of NSError describing the error
 */
typedef void (^DHRestfulApiFailureCompletionBlock)(NSError *error);


/**
 `DHRestfulApiClient` protocol defines common interface for classes which encapsulate low-level network interaction with the server via RESTful HTTP protocol.
 */
@protocol DHRestfulApiClient<NSObject>

/**
 Connection timeout interval value
 */
@property (nonatomic) NSTimeInterval timeoutInterval;

/** Perform GET request to the given path and with passed parameters.
 @param path Path to perform request for
 @param parameters Parameters to be passed along with the request
 @param success Success completion block.
 @param failure Failure completion block
 */
- (void)get:(NSString*)path
 parameters:(NSDictionary*)parameters
    success:(DHRestfulApiSuccessCompletionBlock)success
    failure:(DHRestfulApiFailureCompletionBlock)failure;

/** Perform PUT request to the given path and with passed parameters.
 @param path Path to perform request for
 @param parameters Parameters to be passed along with the request
 @param success Success completion block.
 @param failure Failure completion block
 */
- (void)put:(NSString*)path
 parameters:(NSDictionary*)parameters
    success:(DHRestfulApiSuccessCompletionBlock)success
    failure:(DHRestfulApiFailureCompletionBlock)failure;

/** Perform POST request to the given path and with passed parameters.
 @param path Path to perform request for
 @param parameters Parameters to be passed along with the request
 @param success Success completion block.
 @param failure Failure completion block
 */
- (void)post:(NSString*)path
  parameters:(NSDictionary*)parameters
     success:(DHRestfulApiSuccessCompletionBlock)success
     failure:(DHRestfulApiFailureCompletionBlock)failure;

/** Set header value.
 @param header Header name
 @param value Header value
 */
- (void)setHeader:(NSString *)header
            value:(NSString *)value;

/** Set Basic Authorisation header value.
 @param username Username string.
 @param password Password string.
 */
- (void)setAuthorisationWithUsername:(NSString *)username
                            password:(NSString *)password;

@end
