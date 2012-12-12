//
//  AuthViewController.m
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/11/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "AuthViewController.h"

@interface AuthViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation AuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.usernameTextField.text = self.lastUsername;
    self.passwordTextField.text = self.lastPassword;
    if (self.cancelable) {
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                target:self
                                                                                action:@selector(cancelButtonClicked:)];
        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Authorization"];
        item.leftBarButtonItem = cancelButton;
        item.hidesBackButton = YES;
        [self.navigationBar pushNavigationItem:item animated:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)authenticateButtonClicked:(UIButton *)sender {
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
    } else {
        [self.delegate authViewController:self
                        didObtainUsername:self.usernameTextField.text
                                 password:self.passwordTextField.text];
    }
    
}

- (IBAction)cancelButtonClicked:(UIBarButtonItem *)sender {
    [self.delegate authViewControllerDidCancel:self];
}

@end
