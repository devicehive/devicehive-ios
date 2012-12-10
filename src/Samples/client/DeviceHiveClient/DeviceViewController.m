//
//  DeviceViewController.m
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/10/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DeviceViewController.h"
#import "DHDeviceData.h"
#import "DHDeviceClass.h"
#import "DHDeviceClient.h"

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
        return 2;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Device Info Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Device ID";
            cell.detailTextLabel.text = self.deviceClient.deviceData.deviceID;
        } else {
            cell.textLabel.text = @"Device Status";
            cell.detailTextLabel.text = self.deviceClient.deviceData.status;
        }
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = self.deviceClient.deviceData.deviceClass.name;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Version";
            cell.detailTextLabel.text = self.deviceClient.deviceData.deviceClass.version;
        } else {
            cell.textLabel.text = @"Is Permanent";
            cell.detailTextLabel.text = self.deviceClient.deviceData.deviceClass.isPermanent ? @"YES" : @"NO";
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
