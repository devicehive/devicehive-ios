//
//  SendCommandViewController.m
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "SendNotificationViewController.h"
#import "DHDevice.h"
#import "DHNotification.h"

@interface SendNotificationViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *notificationNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *equipmentCodeTextField;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@end

@implementation SendNotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.notificationNameTextField.delegate = self;
    self.equipmentCodeTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)sendNotificationButtonClicked:(UIButton *)sender {
    NSString* commandName = self.notificationNameTextField.text;
    if (!commandName || !commandName.length) {
        commandName = @"TestCommand";
    }
    
    NSMutableDictionary* parameters = nil;
    NSString* equipmentCode =self.equipmentCodeTextField.text;
    if (equipmentCode && equipmentCode.length > 0) {
        parameters = [NSMutableDictionary dictionary];
        parameters[@"equipment"] = equipmentCode;
    }
    
    DHNotification* notification = [[DHNotification alloc] initWithName:commandName parameters:parameters];
    [self.device sendNotification:notification success:^(id response) {
        NSLog(@"Notification has been sent");
        self.logTextView.text = [NSString stringWithFormat:@"%@\n%@", self.logTextView.text, [notification description]];
    } failure:^(NSError *error) {
        NSLog(@"Failed to send notification: %@", [error description]);
        self.logTextView.text = [NSString stringWithFormat:@"%@Failed to send notification:\n%@", self.logTextView.text, [error description]];
    }];

}

@end
