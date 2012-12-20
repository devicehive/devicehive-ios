//
//  ParametersViewController.h
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/13/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ParametersViewControllerDelegate;

@interface ParametersViewController : UITableViewController

@property (nonatomic, strong) NSDictionary* parameters;

@property (nonatomic, weak) id<ParametersViewControllerDelegate> delegate;

@end

@protocol ParametersViewControllerDelegate <NSObject>

- (void)parametersViewController:(ParametersViewController *)viewController
      didFinishEditingParameters:(NSDictionary *)parameters;

- (void)parametersViewControllerDidCancel:(ParametersViewController *)viewController;

@end
