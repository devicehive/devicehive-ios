//
//  DHDeviceClient.m
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/30/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHLog.h"
#import "DHDeviceClient.h"
#import "DHQueue.h"
#import "DHEntity.h"
#import "DHEntity+SerializationPrivate.h"
#import "DHNotification.h"

typedef void (^DHNotificationPollCompletionBlock)(BOOL success);


@interface DHDeviceClient ()

@property (nonatomic, strong, readwrite) DHDeviceData* deviceData;
@property (nonatomic, strong, readwrite) id<DHClientService> clientService;
@property (nonatomic, readwrite) BOOL isReceivingNotifications;

@property (nonatomic, strong) DHQueue* notificationQueue;
@property (nonatomic) BOOL isNotificationsPollRequestInProgress;

@end

@implementation DHDeviceClient

- (id)initWithDevice:(DHDeviceData *)device
       clientService:(id<DHClientService>)clientService {
    self = [super init];
    if (self) {
        _deviceData = device;
        _clientService = clientService;
        _isReceivingNotifications = NO;
        _isNotificationsPollRequestInProgress = NO;
        _notificationQueue = [DHQueue queue];

    }
    return self;
}

- (void)beginReceivingNotifications {
    if (self.isReceivingNotifications) {
        [self stopReceivingNotifications];
    }
    self.isReceivingNotifications = YES;
    if ([self.delegate respondsToSelector:@selector(deviceClientWillBeginReceivingNotifications:)]) {
        [self.delegate deviceClientWillBeginReceivingNotifications:self];
    }
    [self handleNextNotificationForDevice:self.deviceData];
}

- (void)stopReceivingNotifications {
    self.isReceivingNotifications = NO;
    if ([self.delegate respondsToSelector:@selector(deviceClientDidStopReceivingNotifications:)]) {
        [self.delegate deviceClientDidStopReceivingNotifications:self];
    }
}


- (void)handleNextNotificationForDevice:(DHDeviceData*)device {
    if (self.isReceivingNotifications) {
        if (!self.isNotificationsPollRequestInProgress) {
            DHNotification* notification = [self.notificationQueue dequeueObject];
            if (notification) {
                if ([self.delegate respondsToSelector:@selector(deviceClient:didReceiveNotification:)]) {
                    [self.delegate deviceClient:self didReceiveNotification:notification];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self handleNextNotificationForDevice:device];
                });
            } else {
                [self pollNextNotificationForDevice:device completion:^(BOOL success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self handleNextNotificationForDevice:device];
                    });
                }];
            }
        }
    }
}

- (void)pollNextNotificationForDevice:(DHDeviceData*)device
                           completion:(DHNotificationPollCompletionBlock)completion {
    // we already have one poll request in progress just wait for it to finish
    if (!self.isNotificationsPollRequestInProgress) {
        DHLog(@"Poll next notification for device: %@ starting from date: (%@)",
              device.name, self.lastNotificationPollTimestamp);
        self.isNotificationsPollRequestInProgress = YES;
        [self.clientService pollDeviceNotifications:device
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
    if ([self.delegate respondsToSelector:@selector(deviceClient:willSendCommand:)]) {
        [self.delegate deviceClient:self willSendCommand:command];
    }
    [self.clientService sendCommand:command forDevice:self.deviceData completion:^(id response) {
        if ([self.delegate respondsToSelector:@selector(deviceClient:didSendCommand:)]) {
            [self.delegate deviceClient:self didSendCommand:command];
        }
        success(response);
    } failure:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(deviceClient:didFailSendCommand:withError:)]) {
            [self.delegate deviceClient:self didFailSendCommand:command withError:error];
        }
        failure(error);
    }];
}

@end
