//
//  DHRestfulClientService.m
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/30/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHLog.h"
#import "DHRestfulClientService.h"
#import "DHEntity.h"
#import "DHEntity+SerializationPrivate.h"
#import "DHNetwork.h"
#import "DHDeviceData.h"
#import "DHDeviceClass.h"
#import "DHEquipmentData.h"
#import "DHNotification.h"
#import "DHCommand.h"
#import "DHEquipmentState.h"
#import "DHUtils.h"

@interface DHRestfulClientService ()

@end

@implementation DHRestfulClientService

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)getNetworksWithCompletion:(DHServiceSuccessCompletionBlock)success
                          failure:(DHServiceFailureCompletionBlock)failure {
    
    [self.restfulApiClient get:@"network"
                    parameters:nil
                       success:^(id response) {
                           NSArray* networks = [DHNetwork fromArrayOfDictionaries:response];
                           DHLog(@"Received networks:%@", [networks description]);
                           success(networks);
                       } failure:^(NSError *error) {
                           DHLog(@"Failed to retrieve networks with error:%@", error);
                           failure(error);
                       }
     ];
}

- (void)getDevicesOfNetwork:(DHNetwork *)network
                 completion:(DHServiceSuccessCompletionBlock)success
                    failure:(DHServiceFailureCompletionBlock)failure {
    
    NSString* path = [NSString stringWithFormat:@"network/%@", network.networkID];
    [self.restfulApiClient get:path
                    parameters:nil
                       success:^(id response) {
                           NSArray* devices = [DHDeviceData fromArrayOfDictionaries:[response objectForKey:@"devices"]];
                           DHLog(@"Received devices:%@", [devices description]);
                           success(devices);
                       } failure:^(NSError *error) {
                           DHLog(@"Failed to retrieve devices with error:%@", error);
                           failure(error);
                       }
     ];
}

- (void)getDeviceWithId:(NSString *)deviceId
             completion:(DHServiceSuccessCompletionBlock)success
                failure:(DHServiceFailureCompletionBlock)failure {
    
    NSString* path = [NSString stringWithFormat:@"device/%@", deviceId];
    [self.restfulApiClient get:path
                    parameters:nil
                       success:^(id response) {
                           DHLog(@"Received device:%@", [response description]);
                           success([[DHDeviceData alloc] initWithDictionary:response]);
                       } failure:^(NSError *error) {
                           DHLog(@"Failed to retrieve device(%@) with error:%@", deviceId, error);
                           failure(error);
                       }
     ];
}

- (void)getEquipmentOfDeviceClass:(DHDeviceClass *)deviceClass
                       completion:(DHServiceSuccessCompletionBlock)success
                          failure:(DHServiceFailureCompletionBlock)failure {
    
    NSString* path = [NSString stringWithFormat:@"device/class/%@", deviceClass.deviceClassID];
    [self.restfulApiClient get:path
                    parameters:nil
                       success:^(id response) {
                           NSArray* equipment = [DHEquipmentData fromArrayOfDictionaries:[response objectForKey:@"equipment"]];
                           DHLog(@"Received equipment:%@", [equipment description]);
                           success(equipment);
                       } failure:^(NSError *error) {
                           DHLog(@"Failed to retrieve equipment for device class(%@) with error:%@", deviceClass.deviceClassID, error);
                           failure(error);
                       }
     ];

}

- (void)pollDeviceNotifications:(DHDeviceData *)device
                          since:(NSString *)lastNotificationPollTimestamp
                    waitTimeout:(NSNumber *)waitTimeout
                     completion:(DHServiceSuccessCompletionBlock)success
                        failure:(DHServiceFailureCompletionBlock)failure {
    
    NSMutableString *path = [NSMutableString stringWithFormat:@"device/%@/notification/poll", device.deviceID];
    if (lastNotificationPollTimestamp.length > 0) {
        [path appendFormat:@"?timestamp=%@", encodeToPercentEscapeString(lastNotificationPollTimestamp)];
    }
    
    if (waitTimeout) {
        [path appendString:lastNotificationPollTimestamp.length > 0 ? @"&" : @"?"];
        [path appendFormat:@"waitTimeout=%@", waitTimeout];
    }
    [self.restfulApiClient get:path
                    parameters:nil
                       success:^(id response) {
                           NSArray* notifications = [DHNotification fromArrayOfDictionaries:response];
                           DHLog(@"Received notifications:%@", [notifications description]);
                           success(notifications);
                       } failure:^(NSError *error) {
                           DHLog(@"Failed to retrieve notifications for device(%@) with error:%@", device.deviceID, error);
                           failure(error);
                       }
     ];
}

- (void)getDeviceNotifications:(DHDeviceData *)device
                         since:(NSString *)lastNotificationPollTimestamp
                    completion:(DHServiceSuccessCompletionBlock)success
                       failure:(DHServiceFailureCompletionBlock)failure {
    
    NSMutableString *path = [NSMutableString stringWithFormat:@"device/%@/notification", device.deviceID];
    if (lastNotificationPollTimestamp && lastNotificationPollTimestamp.length > 0) {
        [path appendFormat:@"?start=%@", encodeToPercentEscapeString(lastNotificationPollTimestamp)];
    }
    [self.restfulApiClient get:path
                    parameters:nil
                       success:^(id response) {
                           NSArray* notifications = [DHNotification fromArrayOfDictionaries:response];
                           DHLog(@"Received notifications:%@", [notifications description]);
                           success(notifications);
                       } failure:^(NSError *error) {
                           DHLog(@"Failed to retrieve notifications for device(%@) with error:%@", device.deviceID, error);
                           failure(error);
                       }
     ];

}

- (void)pollDevicesNotifications:(NSArray *)devices
                           since:(NSString *)lastNotificationPollTimestamp
                     waitTimeout:(NSNumber *)waitTimeout
                      completion:(DHServiceSuccessCompletionBlock)success
                         failure:(DHServiceFailureCompletionBlock)failure {
    NSMutableString *path = [NSMutableString stringWithFormat:@"device/notification/poll"];
    if (devices.count) {
        [path appendFormat:@"?deviceGuids=%@", [self prepareGuidsString:devices]];
    }
    if (lastNotificationPollTimestamp.length > 0) {
        [path appendString:devices.count ? @"&" : @"?"];
        [path appendFormat:@"timestamp=%@", encodeToPercentEscapeString(lastNotificationPollTimestamp)];
    }
    
    if (waitTimeout) {
        [path appendString:(lastNotificationPollTimestamp.length > 0 || devices.count) ? @"&" : @"?"];
        [path appendFormat:@"waitTimeout=%@", waitTimeout];
    }
    
    [self.restfulApiClient get:path
                    parameters:nil
                       success:^(NSArray* response) {
                           NSMutableArray* result = [NSMutableArray array];
                           if (response) {
                               for (NSDictionary* notificationDict in response) {
                                   DHNotification* notification = [DHNotification fromDictionary:notificationDict[@"notification"]];
                                   NSString* deviceId = notificationDict[@"deviceGuid"];
                                   [result addObject:@{@"deviceId" : deviceId,
                                                       @"notification" : notification}];
                               }
                           }
                           DHLog(@"Received notifications:%@", [result description]);
                           success(result);
                       } failure:^(NSError *error) {
                           DHLog(@"Failed to retrieve notifications for device(%@) with error:%@", [devices description], error);
                           failure(error);
                       }
     ];
}

- (NSString *)prepareGuidsString:(NSArray *)devices {
    NSMutableString* guidsString = [NSMutableString string];
    [devices enumerateObjectsUsingBlock:^(DHDeviceData* device, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [guidsString appendString:device.deviceID];
        } else {
            [guidsString appendFormat:@",%@", device.deviceID];
        }
    }];
    return guidsString;
}


- (void)sendCommand:(DHCommand *)command
          forDevice:(DHDeviceData *)device
         completion:(DHServiceSuccessCompletionBlock)success
            failure:(DHServiceFailureCompletionBlock)failure {
    
    NSString* path = [NSString stringWithFormat:@"device/%@/command", device.deviceID];
    [self.restfulApiClient post:path
                     parameters:[command classDictionary]
                        success:^(id response) {
                            DHCommand* command = [[DHCommand alloc] initWithDictionary:response];
                            DHLog(@"Received response command:%@", [command description]);
                            success(command);
                        } failure:^(NSError *error) {
                            DHLog(@"Failed to send command for device(%@) with error:%@", device.deviceID, error);
                            failure(error);
                        }
     ];

}

- (void)getEquipmentStateOfDevice:(DHDeviceData *)device
                       completion:(DHServiceSuccessCompletionBlock)success
                          failure:(DHServiceFailureCompletionBlock)failure {
    
    NSString *path = [NSMutableString stringWithFormat:@"device/%@/equipment", device.deviceID];
    [self.restfulApiClient get:path
                    parameters:nil
                       success:^(id response) {
                           NSArray* equipmentState = [DHEquipmentState fromArrayOfDictionaries:response];
                           DHLog(@"Received equipment state:%@", [equipmentState description]);
                           success(equipmentState);
                       } failure:^(NSError *error) {
                           DHLog(@"Failed to retrieve equipment state for device(%@) with error:%@", device.deviceID, error);
                           failure(error);
                       }
     ];

}

- (void)getCommandWithId:(NSNumber *)commandId
            sentToDevice:(DHDeviceData *)device
              completion:(DHServiceSuccessCompletionBlock)success
                 failure:(DHServiceFailureCompletionBlock)failure {
    
    NSString *path = [NSMutableString stringWithFormat:@"device/%@/command/%@", device.deviceID, commandId];
    [self.restfulApiClient get:path
                    parameters:nil
                       success:^(id response) {
                           DHCommand* command = [[DHCommand alloc] initWithDictionary:response];
                           DHLog(@"Received command: %@", command);
                           success(command);
                       } failure:^(NSError *error) {
                           DHLog(@"Failed to retrieve command with id(%@) for device(%@) with error:%@", commandId, device.deviceID, error);
                           failure(error);
                       }
     ];
}

@end
