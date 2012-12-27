//
//  DHCommandExecutor.h
//  DeviceHiveFramework
//
//  Created by Maxim Kiselev on 11/07/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHCommand;
@class DHCommandResult;
@protocol DHDeviceService;

/**
 Completion block which is invoked by the command executor after given command is executed.
 @param result DHCommandResult object representing command result.
 */
typedef void (^DHCommandCompletionBlock)(DHCommandResult* result);


/**
 `DHCommandExecutor` protocol defines common interface for classes which are able to execute commands represented by DHCommand class.
 These are DHDevice and DHEquipment classes.
 */
@protocol DHCommandExecutor <NSObject>

@optional

/**
 Called right before command is executed either by the device itself or one of its equipment. This method is called for the device before each
 * command execution (either by the device itself or one of its equipment).
 @param command DHCommand which is about to be executed. 
 */
- (void)willExecuteCommand:(DHCommand *)command;

@required

/** Execute given command.
 You *MUST* call completion block in the end of your implementation.
 @param command DHCommand instance to be executed.
 @param completion Completion block to be invoked when command execution is finished.
 */
- (void)executeCommand:(DHCommand *)command
            completion:(DHCommandCompletionBlock)completion;

@end
