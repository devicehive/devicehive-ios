//
//  DHErrors.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 12/28/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Device Hive error domain.
 */
extern NSString* const DHErrorDomain;

/**
 Device error code.
 */
extern NSInteger const DHDeviceErrorCode;

/**
 Equipment error code.
 */
extern NSInteger const DHEquipmentErrorCode;

/**
 Client error code.
 */
extern NSInteger const DHClientErrorCode;

/**
 Restful operation error code.
 */
extern NSInteger const DHRestfulOperationErrorCode;

/**
 Key value of `HTTPUrlRequest` object inside userInfo container of `NSError` object.
 */
extern NSString* const DHRestfulOperationFailingUrlRequestErrorKey;

/**
 Key value of `HTTPUrlResponse` object inside userInfo container of `NSError` object.
 */
extern NSString* const DHRestfulOperationFailingUrlResponseErrorKey;

/**
 Error domain.
 */
extern NSString* const DHRestfulOperationErrorDomain;
