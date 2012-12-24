//
//  DHSingleDeviceClient.m
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 12/25/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHLog.h"
#import "DHSingleDeviceClient.h"
#import "DHDeviceClient+Private.h"
#import "DHQueue.h"
#import "DHEntity.h"
#import "DHEntity+SerializationPrivate.h"
#import "DHNotification.h"


@interface DHSingleDeviceClient ()

@property (nonatomic, strong, readwrite) DHDeviceData* deviceData;

@end

@implementation DHSingleDeviceClient

- (id)initWithDevice:(DHDeviceData *)device
       clientService:(id<DHClientService>)clientService {
    self = [super initWithClientService:clientService];
    if (self) {
        _deviceData = device;
    }
    return self;
}

- (void)didReceiveNotification:(id)notification {
    if ([self.delegate conformsToProtocol:@protocol(DHSingleDeviceClientDelegate)]) {
        id<DHSingleDeviceClientDelegate> singleDeviceClientDelegate = (id<DHSingleDeviceClientDelegate>)self.delegate;
        if ([singleDeviceClientDelegate respondsToSelector:@selector(deviceClient:didReceiveNotification:)]) {
            [singleDeviceClientDelegate deviceClient:self didReceiveNotification:notification];
        } else {
            NSLog(@"Single device client delegate doesn't respond to deviceClient:didReceiveNotification: selector. Implement this method in order to receive notifications");
        }
    } else  {
        NSLog(@"Single device client delegate doesn't conforms to DHSingleDeviceClientDelegate protocol. Adopt this protocol in order to receive notifications");
    }
}

- (void)pollNextNotificationsWithCompletion:(DHNotificationPollCompletionBlock)completion {
    // we already have one poll request in progress just wait for it to finish
    if (!self.isNotificationsPollRequestInProgress) {
        DHLog(@"Poll next notification for device: %@ starting from date: (%@)",
              self.deviceData.name, self.lastNotificationPollTimestamp);
        self.isNotificationsPollRequestInProgress = YES;
        [self.clientService pollDeviceNotifications:self.deviceData
                                              since:self.lastNotificationPollTimestamp
                                         completion:^(id response) {
                                             DHLog(@"Got notifications: %@", [response description]);
                                             NSArray* notifications = response;
                                             if (notifications.count > 0) {
                                                 DHNotification* lastNotification = [notifications lastObject];
                                                 self.lastNotificationPollTimestamp = lastNotification.timestamp;
                                             }
                                             [self.notificationQueue enqueueAllObjects:notifications];
                                             DHLog(@"Enqueued notifications count: %d", notifications.count);
                                             self.isNotificationsPollRequestInProgress = NO;
                                             completion(YES);
                                         } failure:^(NSError *error) {
                                             DHLog(@"Failed to poll nottifications with error:%@", error);
                                             self.isNotificationsPollRequestInProgress = NO;
                                             completion(NO);
                                         }];
    }
}

- (void)sendCommand:(DHCommand* )command
            success:(DHDeviceClientSuccessCompletionBlock)success
            failure:(DHDeviceClientFailureCompletionBlock)failure {
    [self sendCommand:command forDevice:self.deviceData success:^(id response) {
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)reloadDeviceDataWithSuccess:(DHDeviceClientSuccessCompletionBlock)success
                            failure:(DHDeviceClientFailureCompletionBlock)failure {
    [self.clientService getDeviceWithId:self.deviceData.deviceID completion:^(DHDeviceData* deviceData) {
        self.deviceData = deviceData;
        success(deviceData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
