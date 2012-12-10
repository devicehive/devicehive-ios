//
//  NetworksViewController.m
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/3/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "NetworksViewController.h"
#import "DHClientService.h"
#import "DHNetwork.h"
#import "NetworkDevicesViewController.h"

@interface NetworksViewController ()

@property (nonatomic, strong) NSArray* networks;

@end

@implementation NetworksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Available Networks";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.clientService getNetworksWithCompletion:^(id response) {
        self.networks = response;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get networks: %@", [error description]);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.networks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Network Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    DHNetwork* network = [self.networks objectAtIndex:indexPath.row];
    cell.textLabel.text = network.name;
    cell.detailTextLabel.text = network.description;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Network Devices Segue"]) {
        NetworkDevicesViewController* networkDeviceViewController = (NetworkDevicesViewController*)segue.destinationViewController;
        networkDeviceViewController.clientService = self.clientService;
        networkDeviceViewController.network = [self.networks objectAtIndex:[[self.tableView indexPathForCell:sender] row]];
    }
}

@end
