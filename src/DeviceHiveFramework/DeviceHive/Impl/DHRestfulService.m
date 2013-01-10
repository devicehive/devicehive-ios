//
//  DHRestfulService.m
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 1/10/13.
//  Copyright (c) 2013 DataArt Apps. All rights reserved.
//

#import "DHRestfulService.h"
#import "DHLog.h"
#import "DHApiInfo.h"
#import "DHEntity+SerializationPrivate.h"

@interface DHRestfulService ()

@property (nonatomic, strong, readwrite) id<DHRestfulApiClient> restfulApiClient;

@end

@implementation DHRestfulService

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithApiClient:(id<DHRestfulApiClient>)restfulApiClient {
    self = [super init];
    if (self) {
        _restfulApiClient = restfulApiClient;
    }
    return self;
}

- (void)getApiInfoWithSuccess:(DHServiceSuccessCompletionBlock)success
                      failure:(DHServiceFailureCompletionBlock)failure {
    DHLog(@"Getting service meta-information");
    [self.restfulApiClient get:@"info"
                    parameters:nil
                       success:^(id response) {
                           DHLog(@"Received service meta-information:%@", [response description]);
                           success([[DHApiInfo alloc] initWithDictionary:response]);
                       } failure:^(NSError *error) {
                           DHLog(@"Failed to receive meta-information:%@", error);
                           failure(error);
                       }
     ];
}

- (void)cancelAllServiceRequests {
    [self.restfulApiClient cancelAllHTTPOperations];
}

@end
