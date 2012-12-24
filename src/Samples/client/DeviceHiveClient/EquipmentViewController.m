//
//  EquipmentViewController.m
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "EquipmentViewController.h"
#import "DHDeviceData.h"
#import "DHDeviceClass.h"
#import "DHSingleDeviceClient.h"
#import "DHEquipmentProtocol.h"
#import "DHEquipmentState.h"

@interface EquipmentViewController ()

@property (nonatomic, strong) NSArray* equipment;
@property (nonatomic, strong) NSArray* equipmentState;

@end

@implementation EquipmentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadEquipmentData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.equipment.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Equipment Info Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    id<DHEquipmentProtocol> eq = [self.equipment objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Code";
        cell.detailTextLabel.text = eq.code;
    } else if (indexPath.row == 1){
        cell.textLabel.text = @"Type";
        cell.detailTextLabel.text = eq.type;
    } else {
        DHEquipmentState* state = [self equipmentStateForEquipment:eq];
        cell.textLabel.text = @"State";
        cell.detailTextLabel.text = state.parameters ? [state.parameters description] : @"--";
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<DHEquipmentProtocol> eq = [self.equipment objectAtIndex:section];
    return eq.name;
}

- (DHEquipmentState *)equipmentStateForEquipment:(id<DHEquipmentProtocol>)equipment {
    for (DHEquipmentState* state in self.equipmentState) {
        if ([state.code isEqualToString:equipment.code]) {
            return state;
        }
    }
    return nil;
}

- (void)reloadEquipmentData {
    [self.deviceClient.clientService getEquipmentOfDeviceClass:self.deviceClient.deviceData.deviceClass
                                                    completion:^(NSArray* equipment) {
                                                        self.equipment = equipment;
                                                        [self.deviceClient.clientService getEquipmentStateOfDevice:self.deviceClient.deviceData completion:^(NSArray* equipmentState) {
                                                            self.equipmentState = equipmentState;
                                                            [self.tableView reloadData];
                                                        } failure:^(NSError *error) {
                                                            NSLog(@"Failed to get device(%@) equipment state with error: %@", self.deviceClient.deviceData.name,
                                                                  [error description]);
                                                            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                                                                message:@"Failed to get equipment state. Please, retry."
                                                                                                               delegate:self
                                                                                                      cancelButtonTitle:@"OK"
                                                                                                      otherButtonTitles:nil];
                                                            [alertView show];
                                                            
                                                        }];
                                                    } failure:^(NSError *error) {
                                                        NSLog(@"Failed to get device(%@) equipment with error: %@", self.deviceClient.deviceData.name,
                                                              [error description]);
                                                        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                                                            message:@"Failed to get equipment. Please, retry."
                                                                                                           delegate:self
                                                                                                  cancelButtonTitle:@"OK"
                                                                                                  otherButtonTitles:nil];
                                                        [alertView show];
                                                    }];
    
}

- (void)refresh {
    [self reloadEquipmentData];
}

@end
