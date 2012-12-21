//
//  SettingsViewController.h
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/21/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate;

@interface SettingsViewController : UITableViewController

@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString* lastServerUrl;

@property (nonatomic) BOOL cancelable;

@end


@protocol SettingsViewControllerDelegate <NSObject>

- (void)settingsViewController:(SettingsViewController *)settingsViewController
            didChangeServerURL:(NSString *)url;

- (void)settingsViewControllerDidCancel:(SettingsViewController *)settingsViewController;

@end