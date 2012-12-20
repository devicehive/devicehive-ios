//
//  EquipmentSelectorViewController.m
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 12/14/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "EquipmentSelectorViewController.h"
#import "DHEquipmentProtocol.h"

@interface EquipmentSelectorViewController ()

@end

@implementation EquipmentSelectorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)doneButtonClicked:(UIBarButtonItem *)sender {
    [self.delegate equipmentSelectorViewController:self
                                didSelectEquipment:self.selectedEquipment];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self.delegate equipmentSelectorViewControllerDidCancel:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.equipment.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Equipment Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"None";
        if (!self.selectedEquipment) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else {
        id<DHEquipmentProtocol> eq = [self.equipment objectAtIndex:indexPath.row - 1];
        cell.textLabel.text = eq.name;
        if ([self.selectedEquipment.code isEqualToString:eq.code]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.selectedEquipment = nil;
    } else {
        self.selectedEquipment = [self.equipment objectAtIndex:indexPath.row - 1];
    }
    [self.tableView reloadData];
}

@end
