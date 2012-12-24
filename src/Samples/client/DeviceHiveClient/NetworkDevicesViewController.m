//
//  NetworkDevicesViewController.m
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/3/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "NetworkDevicesViewController.h"
#import "DHNetwork.h"
#import "DHDeviceData.h"
#import "DHDeviceClass.h"
#import "DHClientService.h"
#import "DeviceViewController.h"
#import "DHSingleDeviceClient.h"

@interface NetworkDevicesViewController ()

@property (nonatomic, strong) NSArray* devices;

@end

@implementation NetworkDevicesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadDevices];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Device Segue"]) {
        DHDeviceData* deviceData = [self.devices objectAtIndex:[[self.tableView indexPathForCell:sender] row]];
        if ([segue.destinationViewController respondsToSelector:@selector(setDeviceClient:)]) {
            [segue.destinationViewController performSelector:@selector(setDeviceClient:)
                                                  withObject:[[DHSingleDeviceClient alloc] initWithDevice:deviceData
                                               clientService:self.clientService]];
        }
    }
}

- (IBAction)refreshButtonClicked:(UIBarButtonItem *)sender {
    [self reloadDevices];
}

- (void)reloadDevices {
    [self.clientService getDevicesOfNetwork:self.network completion:^(NSArray* devices) {
        self.devices = [devices sortedArrayUsingComparator:^NSComparisonResult(DHDeviceData* device1, DHDeviceData* device2) {
            return [device1.name compare:device2.name];
        }];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get devices: %@", [error description]);
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"Failed to get devices. Please, retry."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.devices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Network Device Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    DHDeviceData* device = [self.devices objectAtIndex:indexPath.row];
    cell.textLabel.text = device.name;
    cell.detailTextLabel.text = device.deviceClass.name;
    
    return cell;
}

@end
