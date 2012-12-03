//
//  DHIDeviceService.h
//  DeviceHiveDevice
//
//  Created by Maxim Kiselev on 11/07/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHCommand;
@class DHCommandResult;
@protocol DHDeviceService;

/**
 Completion block which is invoked by the command executor after given command is executed.
 @param result DHCommandResult object representing command result
 */
typedef void (^DHCommandCompletionBlock)(DHCommandResult* result);


/**
 `DHCommandExecutor` protocol defines common interface for classes which are able to execute commands represented by DHCommand class.
 These are DHDevice and DHEquipment classes.
 */
@protocol DHCommandExecutor <NSObject>

/** Check if the executor should execute the given command.
 @param command DHCommand instance to be executed
 @return YES if the command should be executed(leads to subsequent `executeCommand:(DHCommand*)command
 completion:(DHCommandCompletionBlock)completion` method call), otherwise return NO. If this methods returns NO the command won't be executed
 */
- (BOOL)shouldExecuteCommand:(DHCommand*)command;

/** Execute the given command.
 You *MUST* call completion block in the end of your implementation
 @param command DHCommand instance to be executed
 @param completion Completion block to be invoked when command execution is finished
 */
- (void)executeCommand:(DHCommand*)command
            completion:(DHCommandCompletionBlock)completion;

@end
