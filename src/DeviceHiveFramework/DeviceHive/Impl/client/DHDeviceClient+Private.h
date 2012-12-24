//
//  DHDeviceClient.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 12/25/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHDevice.h"
#import "DHQueue.h"

typedef void (^DHNotificationPollCompletionBlock)(BOOL success);

@interface DHDeviceClient(Private)

@property (nonatomic, readwrite) BOOL isReceivingNotifications;
@property (nonatomic) BOOL isNotificationsPollRequestInProgress;
@property (nonatomic, strong, readonly) DHQueue* notificationQueue;

- (void)sendCommand:(DHCommand* )command
          forDevice:(DHDeviceData* )deviceData
            success:(DHDeviceClientSuccessCompletionBlock)success
            failure:(DHDeviceClientFailureCompletionBlock)failure;

- (void)didReceiveNotification:(id)notification;
- (void)pollNextNotificationsWithCompletion:(DHNotificationPollCompletionBlock)completion;

@end
