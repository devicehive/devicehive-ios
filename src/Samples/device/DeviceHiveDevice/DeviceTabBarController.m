//
//  DeviceTabBarController.m
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DeviceTabBarController.h"
#import "DHDeviceData.h"
#import "DHDevice.h"
#import "DHCommand.h"
#import "SettingsViewController.h"
#import "Constants.h"
#import "SampleDeviceAppDelegate.h"


NSString* const DeviceClientDidReceiveNotification = @"DeviceClientDidReceiveNotification";

@interface DeviceTabBarController () <UITabBarControllerDelegate, SettingsViewControllerDelegate>

@end

@implementation DeviceTabBarController 

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    [super setSelectedViewController:selectedViewController];
    if ([selectedViewController respondsToSelector:@selector(setDevice:)]) {
        [selectedViewController performSelector:@selector(setDevice:)
                                     withObject:self.device];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Settings Segue"]) {
        SettingsViewController* settingsViewController = (SettingsViewController*)segue.destinationViewController;
        settingsViewController.delegate = self;
        settingsViewController.cancelable = YES;
        NSString* serverUrl = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultsKeyServerUrl];
        settingsViewController.lastServerUrl = serverUrl ? serverUrl : kDefaultServerUrl;
    }
}

- (void)showSettingsViewController {
    [self performSegueWithIdentifier:@"Settings Segue" sender:self];
}

#pragma mark - SettingsViewControllerDelegate

- (void)settingsViewController:(SettingsViewController *)settingsViewController
            didChangeServerURL:(NSString *)url {
    
    [[NSUserDefaults standardUserDefaults] setObject:url
                                              forKey:DefaultsKeyServerUrl];
    [[SampleDeviceAppDelegate sampleAppDelegate] registerDeviceWithServiceUrl:url
                                                                   completion:^(BOOL success) {
                                                                       if (success) {
                                                                           [self dismissViewControllerAnimated:YES completion:nil];
                                                                           [self.device beginProcessingCommands];
                                                                       } else {
                                                                           UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                                                                               message:@"Failed to register device. Check server URL and try again."
                                                                                                                              delegate:self
                                                                                                                     cancelButtonTitle:@"OK"
                                                                                                                     otherButtonTitles:nil];
                                                                           [alertView show];
                                                                       }
                                                                   }];
}

- (void)settingsViewControllerDidCancel:(SettingsViewController *)settingsViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
