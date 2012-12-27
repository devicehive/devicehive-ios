//
//  DeviceViewController.m
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 12/11/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DeviceViewController.h"
#import "DHDevice.h"

@interface DeviceViewController ()

@end

@implementation DeviceViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Device Info Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Device ID";
            cell.detailTextLabel.text = self.device.deviceData.deviceID;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Device Status";
            cell.detailTextLabel.text = self.device.deviceData.status;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Data";
            cell.detailTextLabel.text = self.device.deviceData.data ? [self.device.deviceData.data description] : @"--";
        }
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = self.device.deviceData.deviceClass.name;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Version";
            cell.detailTextLabel.text = self.device.deviceData.deviceClass.version;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Is Permanent";
            cell.detailTextLabel.text = self.device.deviceData.deviceClass.isPermanent ? @"YES" : @"NO";
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"Data";
            cell.detailTextLabel.text = self.device.deviceData.deviceClass.data ? [self.device.deviceData.deviceClass.data description] : @"--";
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Device";
    } else {
        return @"Device class";
    }
}

@end
