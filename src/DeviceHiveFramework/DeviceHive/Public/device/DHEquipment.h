//
//  DHEquipment.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHCommandExecutor.h"
#import "DHDevice.h"
#import "DHEquipmentData.h"
#import "DHEquipmentNotification.h"


/**
 Completion block which is invoked by an equipment when corresponding operation is finished.
 @param success YES if operation succeeds, otherwise returns NO.
 */
typedef void (^DHEquipmentOperationCompletionBlock)(BOOL success);

/**
 Represents an equipment which is installed on devices.
 */
@interface DHEquipment : NSObject<DHEquipmentProtocol, DHCommandExecutor>

/**
 Corresponding DHDevice object. This property is set by the device during its initialization.
 */
@property (nonatomic, weak, readonly) DHDevice* device;

/**
 Init object with equipment data.
 @param equipmentData DHEquipmentData instance.
 */
- (id)initWithEquipmentData:(DHEquipmentData *)equipmentData;

/** Send equipment notification.
 @param notification DHEquipmentNotification instance.
 @param success Success completion block.
 @param failure Failure completion block.
 */
- (void)sendNotification:(DHEquipmentNotification *)notification
                 success:(DHDeviceSuccessCompletionBlock)success
                 failure:(DHDeviceFailureCompletionBlock)failure;

/** @name Callbacks */

/** Callback method which is called during device registration in order to give equipments an opportunity to perform additional initialisation if required. Override this method to provide custom initialization. 
 @param device Hosting device.
 @return YES if equipment was successfully registred, otherwise returns NO.
 */
- (BOOL)registerEquipmentWithDevice:(DHDevice *)device;

/** Callback method which is called in case of connectivity loss occures to give equipments an opportunity to perform additional deinitialisation (cleanup) if required. Override this method to provide custom behavior for your equipment. 
 @param device Hosting device.
 @return YES if equipment was successfully unregistred, otherwise returns NO.
 */
- (BOOL)unregisterEquipmentWithDevice:(DHDevice *)device;

/** Callback method which is called when hosting device is about to start processing commands.
 @param device Hosting device.
 */
- (void)deviceWillBeginProcessingCommands:(DHDevice *)device;

/** Callback method which is called when hosting device has just stopped processing commands.
 @param device Hosting device.
 */
- (void)deviceDidStopProcessingCommands:(DHDevice *)device;

@end
