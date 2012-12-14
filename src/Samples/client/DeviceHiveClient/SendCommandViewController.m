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
#import "EquipmentSelectorViewController.h"
#import "DHEquipmentProtocol.h"
#import "ParametersViewController.h"

@interface SendCommandViewController () <UITextFieldDelegate, EquipmentSelectorViewControllerDelegate, ParametersViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *commandNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (weak, nonatomic) IBOutlet UILabel *selectedEquimentLabel;
@property (weak, nonatomic) IBOutlet UILabel *parametersCountLabel;

@property (nonatomic, strong) NSArray* equipment;
@property (nonatomic, strong) id<DHEquipmentProtocol> selectedEquipment;

@property (nonatomic, strong) NSDictionary* parameters;

@end

@implementation SendCommandViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.deviceClient.clientService getEquipmentOfDeviceClass:self.deviceClient.deviceData.deviceClass
                                                    completion:^(NSArray* equipment) {
                                                        self.equipment = equipment;
                                                    } failure:^(NSError *error) {
                                                        NSLog(@"Failed to get equipment for device: %@", [error description]);
                                                    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.commandNameTextField.delegate = self;
    self.parametersCountLabel.text = [NSString stringWithFormat:@"%d item(s)", self.parameters.count];
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
    
    NSMutableDictionary* parameters = [self.parameters mutableCopy];
    NSString* equipmentCode = self.selectedEquipment.code;
    if (equipmentCode.length > 0) {
        if (!parameters) {
            parameters = [NSMutableDictionary dictionary];
        }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Equipment Selector Segue"]) {
        EquipmentSelectorViewController* selectorViewController = segue.destinationViewController;
        selectorViewController.equipment = self.equipment;
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
