//
//  EquipmentViewController.m
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 12/13/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "EquipmentViewController.h"
#import "DHDevice.h"
#import "DHEquipmentProtocol.h"

@interface EquipmentViewController ()

@end

@implementation EquipmentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)setDevice:(DHDevice *)device {
    if (_device != device) {
        _device = device;
        if (self.isViewLoaded) {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.device.deviceData.equipment.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Equipment Info Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    id<DHEquipmentProtocol> eq = [self.device.deviceData.equipment objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Code";
        cell.detailTextLabel.text = eq.code;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Type";
        cell.detailTextLabel.text = eq.type;
    } else {
        cell.textLabel.text = @"Data";
        cell.detailTextLabel.text = eq.data ? [eq.data description] : @"--";
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<DHEquipmentProtocol> eq = [self.device.deviceData.equipment objectAtIndex:section];
    return eq.name;
}

@end
