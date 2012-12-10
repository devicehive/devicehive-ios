//
//  SendCommandViewController.m
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "SendCommandViewController.h"
#import "DHDeviceClient.h"
#import "DHCommand.h"

@interface SendCommandViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *commandNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *equipmentCodeTextField;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@end

@implementation SendCommandViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.commandNameTextField.delegate = self;
    self.equipmentCodeTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)sendCommandButtonClicked:(UIButton *)sender {
    NSString* commandName = self.commandNameTextField.text;
    if (!commandName || !commandName.length) {
        commandName = @"TestCommand";
    }
    
    NSMutableDictionary* parameters = nil;
    NSString* equipmentCode =self.equipmentCodeTextField.text;
    if (equipmentCode && equipmentCode.length > 0) {
        parameters = [NSMutableDictionary dictionary];
        parameters[@"equipment"] = equipmentCode;
    }
    
    DHCommand* command = [[DHCommand alloc] initWithName:commandName parameters:parameters];
    [self.deviceClient sendCommand:command success:^(id response) {
        NSLog(@"Command has been sent");
        self.logTextView.text = [NSString stringWithFormat:@"%@\n%@", self.logTextView.text, [command description]];
    } failure:^(NSError *error) {
        NSLog(@"Failed to send command: %@", [error description]);
        self.logTextView.text = [NSString stringWithFormat:@"%@Failed to send command:\n%@", self.logTextView.text, [error description]];
    }];

}

@end
