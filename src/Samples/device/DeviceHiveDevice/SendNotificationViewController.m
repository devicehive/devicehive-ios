//
//  SendCommandViewController.m
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "SendNotificationViewController.h"
#import "DHDevice.h"
#import "DHNotification.h"
#import "DHEquipmentProtocol.h"
#import "ParametersViewController.h"
#import "EquipmentSelectorViewController.h"

@interface SendNotificationViewController () <UITextFieldDelegate, EquipmentSelectorViewControllerDelegate, ParametersViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *notificationNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *equipmentCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *selectedEquimentLabel;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (weak, nonatomic) IBOutlet UILabel *parametersCountLabel;

@property (nonatomic, strong) id<DHEquipmentProtocol> selectedEquipment;

@property (nonatomic, strong) NSDictionary* parameters;

@end

@implementation SendNotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.notificationNameTextField.delegate = self;
    self.equipmentCodeTextField.delegate = self;
    self.parametersCountLabel.text = [NSString stringWithFormat:@"%d item(s)", self.parameters.count];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)sendNotificationButtonClicked:(UIButton *)sender {
    NSString* notificationName = self.notificationNameTextField.text;
    if (!notificationName || !notificationName.length) {
        notificationName = @"TestNotification";
    }
    
    NSMutableDictionary* parameters = [self.parameters mutableCopy];
    NSString* equipmentCode = self.selectedEquipment.code;
    if (equipmentCode.length > 0) {
        if (!parameters) {
            parameters = [NSMutableDictionary dictionary];
        }
        parameters[@"equipment"] = equipmentCode;
    }
    
    DHNotification* notification = [[DHNotification alloc] initWithName:notificationName parameters:parameters];
    [self.device sendNotification:notification success:^(id response) {
        NSLog(@"Notification has been sent");
        self.logTextView.text = [NSString stringWithFormat:@"%@\nSent notificaion: %@", self.logTextView.text, [notification description]];
    } failure:^(NSError *error) {
        NSLog(@"Failed to send notification: %@", [error description]);
        self.logTextView.text = [NSString stringWithFormat:@"%@Failed to send notification:\n%@", self.logTextView.text, [error description]];
    }];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Equipment Selector Segue"]) {
        EquipmentSelectorViewController* selectorViewController = segue.destinationViewController;
        selectorViewController.equipment = self.device.deviceData.equipment;
        selectorViewController.selectedEquipment = self.selectedEquipment;
        selectorViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"Parameters Segue"]) {
        ParametersViewController* parametersViewController = segue.destinationViewController;
        parametersViewController.parameters = self.parameters;
        parametersViewController.delegate = self;
    }
}

#pragma mark - EquipmentSelectorViewControllerDelegate

- (void)equipmentSelectorViewController:(EquipmentSelectorViewController *)viewController
                     didSelectEquipment:(id<DHEquipmentProtocol>)equipment {
    
    self.selectedEquipment = equipment;
    if (self.selectedEquipment) {
        self.selectedEquimentLabel.text = self.selectedEquipment.name;
    } else {
        self.selectedEquimentLabel.text = @"None";
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)equipmentSelectorViewControllerDidCancel:(EquipmentSelectorViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ParametersViewControllerDelegate

- (void)parametersViewController:(ParametersViewController *)viewController
      didFinishEditingParameters:(NSDictionary *)parameters {
    self.parameters = parameters;
    self.parametersCountLabel.text = [NSString stringWithFormat:@"%d item(s)", self.parameters.count];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)parametersViewControllerDidCancel:(ParametersViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
