//
//  NetworkDevicesViewController.m
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/3/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "NetworkDevicesViewController.h"
#import "DHNetwork.h"
#import "DHDeviceData.h"
#import "DHDeviceClass.h"
#import "DHClientService.h"
#import "DeviceViewController.h"

@interface NetworkDevicesViewController ()

@property (nonatomic, strong) NSArray* devices;

@end

@implementation NetworkDevicesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.network.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.clientService getDevicesOfNetwork:self.network completion:^(id response) {
        self.devices = response;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get devices: %@", [error description]);
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Device Segue"]) {
        DeviceViewController* deviceViewController = (DeviceViewController*)segue.destinationViewController;
        deviceViewController.clientService = self.clientService;
        deviceViewController.deviceData = [self.devices objectAtIndex:[[self.tableView indexPathForCell:sender] row]];
    }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    DHDeviceData* device = [self.devices objectAtIndex:indexPath.row];
    cell.textLabel.text = device.name;
    cell.detailTextLabel.text = device.deviceClass.name;
    
    return cell;
}

@end
