//
//  SettingsViewController.m
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/11/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *serverUrlTextField;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.serverUrlTextField.delegate = self;
    self.usernameTextField.text = self.lastUsername;
    self.passwordTextField.text = self.lastPassword;
    self.serverUrlTextField.text = self.lastServerUrl;
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Settings"];
    item.hidesBackButton = YES;
    item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                            target:self
                                                                            action:@selector(doneButtonClicked:)];
    if (self.cancelable) {
        item.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                target:self
                                                                                action:@selector(cancelButtonClicked:)];
    }
    [self.navigationBar pushNavigationItem:item animated:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (void)cancelButtonClicked:(UIBarButtonItem *)sender {
    [self.delegate settingsViewControllerDidCancel:self];
}

- (void)doneButtonClicked:(UIBarButtonItem *)sender {
    if (!self.usernameTextField.text.length) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"Username is required"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    } else if (!self.passwordTextField.text.length) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"Password is required"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    } else if (!self.serverUrlTextField.text.length) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"Server url is required"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        [self.delegate settingsViewController:self
                           didChangeServerURL:self.serverUrlTextField.text
                                     username:self.usernameTextField.text
                                     password:self.passwordTextField.text];
    }
}

@end
