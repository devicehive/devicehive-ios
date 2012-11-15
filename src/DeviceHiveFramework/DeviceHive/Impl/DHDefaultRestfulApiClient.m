//
//  DHDeviceApi.m
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 10/15/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHDefaultRestfulApiClient.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"


@interface DHHttpClient : AFHTTPClient 

@property (nonatomic) NSTimeInterval timeoutInterval;

@end

@implementation DHHttpClient

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableURLRequest* request = [super requestWithMethod:method path:path parameters:parameters];
    if (self.timeoutInterval) {
        request.timeoutInterval = self.timeoutInterval;
    }
    return request;
}

@end



@interface DHDefaultRestfulApiClient()

@property (nonatomic, strong) DHHttpClient* client;

@end


@implementation DHDefaultRestfulApiClient

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _client = [[DHHttpClient alloc] initWithBaseURL:url];
        [self.client setDefaultHeader:@"Accept" value:@"application/json"];
        [self.client setParameterEncoding:AFJSONParameterEncoding];
        [self.client setDefaultHeader:@"User-Agent" value:@"DeviceHive (Objective C; iOS)"];
        [self.client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    return self;
}

- (void)get:(NSString*)path
 parameters:(NSDictionary*)parameters
    success:(DHRestfulApiSuccessCompletionBlock) success
    failure:(DHRestfulApiFailureCompletionBlock) failure {
    
    [self.client getPath:path
              parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     success(responseObject);
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     failure(error);
                 }];
}

- (void)post:(NSString*)path
  parameters:(NSDictionary*)parameters
     success:(DHRestfulApiSuccessCompletionBlock) success
     failure:(DHRestfulApiFailureCompletionBlock) failure {
    
    [self.client postPath:path
               parameters:parameters
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      success(responseObject);
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      failure(error);
                  }];
}

- (void)put:(NSString*)path
 parameters:(NSDictionary*)parameters
    success:(DHRestfulApiSuccessCompletionBlock) success
    failure:(DHRestfulApiFailureCompletionBlock) failure {
    
    [self.client putPath:path
              parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     success(responseObject);
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     failure(error);
                 }];
}

- (void)setHeader:(NSString *)header value:(NSString *)value {
	[self.client setDefaultHeader:header value:value];
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    self.client.timeoutInterval = timeoutInterval;
}

- (NSTimeInterval)timeoutInterval {
    return self.client.timeoutInterval;
}


@end
