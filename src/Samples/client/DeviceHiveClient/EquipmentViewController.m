//
//  EquipmentViewController.m
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "EquipmentViewController.h"
#import "DHDeviceData.h"
#import "DHDeviceClass.h"
#import "DHDeviceClient.h"
#import "DHEquipmentProtocol.h"

@interface EquipmentViewController ()

@property (nonatomic, strong) NSArray* equipment;

@end

@implementation EquipmentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.deviceClient.clientService getEquipmentOfDeviceClass:self.deviceClient.deviceData.deviceClass
                                                    completion:^(NSArray* equipment) {
                                                        self.equipment = equipment;
                                                        [self.tableView reloadData];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.equipment.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Equipment Info Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    id<DHEquipmentProtocol> eq = [self.equipment objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Code";
        cell.detailTextLabel.text = eq.code;
    } else {
        cell.textLabel.text = @"Type";
        cell.detailTextLabel.text = eq.type;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<DHEquipmentProtocol> eq = [self.equipment objectAtIndex:section];
    return eq.name;
}

@end
