//
//  DHDeviceService.m
//  DeviceHiveDevice
//
//  Created by Maxim Kiselev on 11/07/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHRestfulDeviceService.h"
#import "DHDefaultRestfulApiClient.h"
#import "DHDevice.h"
#import "DHEquipment.h"
#import "DHEquipmentData.h"
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

@property (nonatomic, strong) id<DHRestfulApiClient> restfulApiClient;

@end

@implementation DHRestfulDeviceService

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

- (void)registerDevice:(DHDevice*)device
               success:(DHDeviceServiceSuccessCompletionBlock) success
               failure:(DHDeviceServiceFailureCompletionBlock) failure {
    
    NSString* path = [NSString stringWithFormat:@"device/%@", device.deviceData.deviceID];
    [self setupAuthenticationForDevice:device];
    DHLog(@"Registering device: %@", [[device.deviceData classDictionary] description]);
    [self.restfulApiClient put:path
                    parameters:[device.deviceData classDictionary]
                       success:^(id response) {
                           DHLog(@"Registration request finished:%@", [response description]);
                           success([[DHDeviceData alloc] initWithDictionary:response]);
                       } failure:^(NSError *error) {
                           DHLog(@"Registration request failed with error:%@", error);
                           failure(error);
                       }
     ];
}

- (void)sendNotification:(DHNotification*)notification
               forDevice:(DHDevice*)device
                 success:(DHDeviceServiceSuccessCompletionBlock) success
                 failure:(DHDeviceServiceFailureCompletionBlock) failure {
    
    [self setupAuthenticationForDevice:device];
    NSString* path = [NSString stringWithFormat:@"device/%@/notification", device.deviceData.deviceID];
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
            forDevice:(DHDevice*)device
           withResult:(DHCommandResult*)result
              success:(DHDeviceServiceSuccessCompletionBlock) success
              failure:(DHDeviceServiceFailureCompletionBlock) failure {
    
    [self setupAuthenticationForDevice:device];
    
    NSString* path = [NSString stringWithFormat:@"device/%@/command/%@", device.deviceData.deviceID, command.commandID];
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

- (void)pollCommandsForDevice:(DHDevice *)device
                        since:(NSString *)lastCommandPollTimestamp
                   completion:(DHDeviceServiceSuccessCompletionBlock)success
                      failure:(DHDeviceServiceFailureCompletionBlock)failure {
    NSString* path = nil;
    if (lastCommandPollTimestamp) {
        path = [NSString stringWithFormat:@"device/%@/command/poll?timestamp=%@",
                //path = [NSString stringWithFormat:@"device/%@/command/poll?timestamp=%@",
                device.deviceData.deviceID, encodeToPercentEscapeString(lastCommandPollTimestamp)];
    } else {
        path = [NSString stringWithFormat:@"device/%@/command/poll", device.deviceData.deviceID];
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

- (void)setupAuthenticationForDevice:(DHDevice*)device {
    [self.restfulApiClient setHeader:@"Auth-DeviceID"
                               value:device.deviceData.deviceID];
    [self.restfulApiClient setHeader:@"Auth-DeviceKey"
                               value:device.deviceData.key];
}

@end
