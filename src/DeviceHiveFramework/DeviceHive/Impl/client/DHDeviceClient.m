//
//  DHDeviceClient.m
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/30/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHLog.h"
#import "DHDeviceClient.h"
#import "DHQueue.h"
#import "DHEntity.h"
#import "DHEntity+SerializationPrivate.h"
#import "DHNotification.h"
#import "DHDeviceClient+Private.h"


@interface DHDeviceClient ()

@property (nonatomic, strong, readwrite) id<DHClientService> clientService;
@property (nonatomic, readwrite) BOOL isReceivingNotifications;

@property (nonatomic, strong, readwrite) DHQueue* notificationQueue;
@property (nonatomic) BOOL isNotificationsPollRequestInProgress;

@end

@implementation DHDeviceClient

- (id)initWithClientService:(id<DHClientService>)clientService {
    self = [super init];
    if (self) {
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
    [self handleNextNotification];
}

- (void)stopReceivingNotifications {
    self.isReceivingNotifications = NO;
    if ([self.delegate respondsToSelector:@selector(deviceClientDidStopReceivingNotifications:)]) {
        [self.delegate deviceClientDidStopReceivingNotifications:self];
    }
}

- (void)handleNextNotification {
    if (self.isReceivingNotifications) {
        if (!self.isNotificationsPollRequestInProgress) {
            id notification = [self.notificationQueue dequeueObject];
            if (notification) {
                [self didReceiveNotification:notification];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self handleNextNotification];
                });
            } else {
                [self pollNextNotificationsWithCompletion:^(BOOL success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self handleNextNotification];
                    });
                }];
            }
        }
    }
}

- (void)didReceiveNotification:(id)notification {
    
}

- (void)pollNextNotificationsWithCompletion:(DHNotificationPollCompletionBlock)completion {
    
}

- (void)sendCommand:(DHCommand* )command
          forDevice:(DHDeviceData* )deviceData
            success:(DHDeviceClientSuccessCompletionBlock)success
            failure:(DHDeviceClientFailureCompletionBlock)failure {
    if ([self.delegate respondsToSelector:@selector(deviceClient:willSendCommand:)]) {
        [self.delegate deviceClient:self willSendCommand:command];
    }
    [self.clientService sendCommand:command forDevice:deviceData completion:^(id response) {
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
