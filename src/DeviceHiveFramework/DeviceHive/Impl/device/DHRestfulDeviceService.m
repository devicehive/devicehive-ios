//
//  DHRestfulDeviceService.m
//  DeviceHiveFramework
//
//  Created by Maxim Kiselev on 11/07/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHRestfulDeviceService.h"
#import "DHDefaultRestfulApiClient.h"
#import "DHNotification.h"
#import "DHCommand.h"
#import "DHEntity+SerializationPrivate.h"
#import "DHCommandResult.h"
#import "DHDeviceStatusNotification.h"
#import "DHCommandQueue.h"
#import "DHDeviceData.h"
#import "DHCommand+Private.h"
#import "DHLog.h"
#import "DHUtils.h"

@interface DHRestfulDeviceService ()

@end

@implementation DHRestfulDeviceService

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)registerDevice:(DHDeviceData*)device
               success:(DHServiceSuccessCompletionBlock) success
               failure:(DHServiceFailureCompletionBlock) failure {
    
    NSString* path = [NSString stringWithFormat:@"device/%@", device.deviceID];
    [self setupAuthenticationForDevice:device];
    DHLog(@"Registering device: %@", [[device classDictionary] description]);
    [self.restfulApiClient put:path
                    parameters:[device classDictionary]
                       success:^(id response) {
                           DHLog(@"Registration request finished:%@", [response description]);
                           success([[DHDeviceData alloc] initWithDictionary:response]);
                       } failure:^(NSError *error) {
                           DHLog(@"Registration request failed with error:%@", error);
                           failure(error);
                       }
     ];
}

- (void)getDeviceData:(DHDeviceData *)device
           completion:(DHServiceSuccessCompletionBlock)success
              failure:(DHServiceFailureCompletionBlock)failure {
    NSString* path = [NSString stringWithFormat:@"device/%@", device.deviceID];
    [self setupAuthenticationForDevice:device];
    [self.restfulApiClient get:path
                    parameters:nil
                       success:^(id response) {
                           DHLog(@"Received device:%@", [response description]);
                           success([[DHDeviceData alloc] initWithDictionary:response]);
                       } failure:^(NSError *error) {
                           DHLog(@"Failed to retrieve device(%@) with error:%@", device.deviceID, error);
                           failure(error);
                       }
     ];
}

- (void)sendNotification:(DHNotification*)notification
               forDevice:(DHDeviceData*)device
                 success:(DHServiceSuccessCompletionBlock) success
                 failure:(DHServiceFailureCompletionBlock) failure {
    
    [self setupAuthenticationForDevice:device];
    NSString* path = [NSString stringWithFormat:@"device/%@/notification", device.deviceID];
    [self.restfulApiClient post:path
                     parameters:[notification classDictionary]
                        success:^(id response) {
                            DHLog(@"Notification sent:%@", [response description]);
                            success(response);
                        } failure:^(NSError *error) {
                            DHLog(@"Sending notification failed with error:%@", error);
                            failure(error);
                        }];
    
}

- (void)updateCommand:(DHCommand*)command
            forDevice:(DHDeviceData*)device
           withResult:(DHCommandResult*)result
              success:(DHServiceSuccessCompletionBlock) success
              failure:(DHServiceFailureCompletionBlock) failure {
    
    [self setupAuthenticationForDevice:device];
    
    NSString* path = [NSString stringWithFormat:@"device/%@/command/%@", device.deviceID, command.commandID];
    [self.restfulApiClient put:path
                    parameters:[result classDictionary]
                       success:^(id response) {
                           DHLog(@"Command updating finished:%@", command.name);
                           success([[DHCommand alloc] initWithDictionary:response]);
                       } failure:^(NSError *error) {
                           DHLog(@"Command updating failed with error:%@", error);
                           failure(error);
                       }
     ];
}

- (void)pollCommandsForDevice:(DHDeviceData *)device
                        since:(NSString *)lastCommandPollTimestamp
                  waitTimeout:(NSNumber *)waitTimeout
                   completion:(DHServiceSuccessCompletionBlock)success
                      failure:(DHServiceFailureCompletionBlock)failure {
    NSMutableString* path = [NSMutableString stringWithFormat:@"device/%@/command/poll", device.deviceID];
    if (lastCommandPollTimestamp.length > 0) {
        [path appendFormat:@"?timestamp=%@",
         encodeToPercentEscapeString(lastCommandPollTimestamp)];
    }
    if (waitTimeout) {
        [path appendString:lastCommandPollTimestamp.length > 0 ? @"&" : @"?"];
        [path appendFormat:@"waitTimeout=%@", waitTimeout];
    }
    
    [self.restfulApiClient get:path
                    parameters:nil
                       success:^(id response) {
                           DHLog(@"Got commands: %@", [response description]);
                           NSArray* commands = [DHCommand fromArrayOfDictionaries:response];
                           success(commands);
                       } failure:^(NSError *error) {
                           DHLog(@"Failed to poll commands with error:%@", error);
                           failure(error);
                       }
     ];
    
}

- (void)setupAuthenticationForDevice:(DHDeviceData*)device {
    [self.restfulApiClient setHeader:@"Auth-DeviceID"
                               value:device.deviceID];
    [self.restfulApiClient setHeader:@"Auth-DeviceKey"
                               value:device.key];
}

@end
