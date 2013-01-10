//
//  DHMultipleDeviceClient.m
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/30/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHLog.h"
#import "DHMultipleDeviceClient.h"
#import "DHDeviceClient+Private.h"
#import "DHQueue.h"
#import "DHEntity.h"
#import "DHEntity+SerializationPrivate.h"
#import "DHNotification.h"


@interface DHMultipleDeviceClient ()

@property (nonatomic, strong, readwrite) NSArray* devices;

@end

@implementation DHMultipleDeviceClient

- (id)initWithDevices:(NSArray *)devices
       clientService:(id<DHClientService>)clientService {
    self = [super initWithClientService:clientService];
    if (self) {
        _devices = devices;
    }
    return self;
}

- (void)didReceiveNotification:(id)notificationDict {
    DHNotification* notification = notificationDict[@"notification"];
    NSString* deviceId = notificationDict[@"deviceId"];
    if ([self.delegate conformsToProtocol:@protocol(DHMultipleDeviceClientDelegate)]) {
        id<DHMultipleDeviceClientDelegate> multipleDeviceClientDelegate = (id<DHMultipleDeviceClientDelegate>)self.delegate;
        if ([multipleDeviceClientDelegate respondsToSelector:@selector(deviceClient:didReceiveNotification:fromDeviceWithId:)]) {
            [multipleDeviceClientDelegate deviceClient:self didReceiveNotification:notification fromDeviceWithId:deviceId];
        } else {
            NSLog(@"Multiple device client delegate doesn't respond to deviceClient:didReceiveNotification:fromDeviceWithId selector. Implement this method in order to receive notifications");
        }
    } else  {
        NSLog(@"Multiple device client delegate doesn't conforms to DHMultipleDeviceClientDelegate protocol. Adopt this protocol in order to receive notifications");
    }
}

- (void)pollNextNotificationsWithCompletion:(DHNotificationPollCompletionBlock)completion {
    DHLog(@"Poll next notification for devices: %@ starting from date: (%@)",
          [self.devices description], self.lastNotificationPollTimestamp);
    [self.clientService pollDevicesNotifications:self.devices
                                           since:self.lastNotificationPollTimestamp
                                      completion:^(NSArray* notifications) {
                                          DHLog(@"Got notifications: %@", [notifications description]);
                                          if (notifications.count > 0) {
                                              DHNotification* lastNotification = [notifications lastObject][@"notification"];
                                              self.lastNotificationPollTimestamp = lastNotification.timestamp;
                                              [self.notificationQueue enqueueAllObjects:notifications];
                                          }
                                          DHLog(@"Enqueued notifications count: %d", notifications.count);
                                          completion(YES);
                                      } failure:^(NSError *error) {
                                          DHLog(@"Failed to poll notifications with error:%@", error);
                                          completion(NO);
                                      }];
}

- (void)sendCommand:(DHCommand* )command
          forDevice:(DHDeviceData *)device
            success:(DHDeviceClientSuccessCompletionBlock)success
            failure:(DHDeviceClientFailureCompletionBlock)failure {
    [super sendCommand:command forDevice:device success:success failure:failure];
}

- (void)reloadDeviceData:(DHDeviceData *)deviceData
                 success:(DHDeviceClientSuccessCompletionBlock)success
                 failure:(DHDeviceClientFailureCompletionBlock)failure {
    [self.clientService getDeviceWithId:deviceData.deviceID
                             completion:^(DHDeviceData* newDeviceData) {
        NSMutableArray* devices = [NSMutableArray arrayWithArray:self.devices];
        [devices removeObject:deviceData];
        [devices addObject:newDeviceData];
        self.devices = devices;
        success(deviceData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (DHDeviceData *)getDeviceDataWithId:(NSString *)deviceId {
    for (DHDeviceData* deviceData in self.devices) {
        if ([deviceData.deviceID isEqualToString:deviceId]) {
            return deviceData;
        }
    }
    return nil;
}

@end
