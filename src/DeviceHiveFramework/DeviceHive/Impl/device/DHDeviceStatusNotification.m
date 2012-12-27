//
//  DHDeviceStatusNotification.m
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/9/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHDeviceStatusNotification.h"

NSString* const DHDeviceStatusOk = @"OK";
NSString* const DHDeviceStatusOnline = @"Online";

@implementation DHDeviceStatusNotification

+ (id)onlineStatusNotification {
    return [[[self class] alloc] initWithDeviceStatus:DHDeviceStatusOnline];
}

+ (id)okStatusNotification {
    return [[[self class] alloc] initWithDeviceStatus:DHDeviceStatusOk];
}

- (id)initWithName:(NSString *)name parameters:(NSDictionary *)parameters {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithDeviceStatus:(NSString*)deviceStatus {
    self = [super initWithName:@"DeviceStatus" parameters:@{@"status" : deviceStatus}];
    if (self) {
        
    }
    return self;
}


@end
