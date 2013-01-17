//
//  DHApiInfo.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 1/10/13.
//  Copyright (c) 2013 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHEntity.h"

/**
 Represents meta-information about the current API.
 */
@interface DHApiInfo : DHEntity

/**
 API version.
 */
@property (nonatomic, strong, readonly) NSString* apiVersion;

/**
 Current server timestamp.
 */
@property (nonatomic, strong, readonly) NSString* serverTimestamp;

/**
 WebSocket server URL.
 */
@property (nonatomic, strong, readonly) NSString* webSocketServerUrl;

@end
