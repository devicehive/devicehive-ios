//
//  NetworksViewController.m
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/3/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "NetworksViewController.h"
#import "DHClientService.h"
#import "DHNetwork.h"
#import "DHErrors.h"
#import "NetworkDevicesViewController.h"
#import "SettingsViewController.h"
#import "DHAppDelegate.h"
#import "DHClientServices.h"
#import "Configuration.h"

NSString* const DefaultsKeyUsername = @"Username";
NSString* const DefaultsKeyPassword = @"Password";
NSString* const DefaultsKeyServerUrl = @"DefaultsKeyServerUrl";

@interface NetworksViewController () <SettingsViewControllerDelegate>

@property (nonatomic, strong) NSArray* networks;

@end

@implementation NetworksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:DefaultsKeyUsername] ||
        ![[NSUserDefaults standardUserDefaults] objectForKey:DefaultsKeyPassword]) {
        [self performSelector:@selector(showSettingsViewController) withObject:nil afterDelay:0.1];
    } else {
        NSString* serverUrl = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultsKeyServerUrl];
        [[DHAppDelegate appDelegate] setupClientServiceWithServerUrl:serverUrl ? serverUrl : kServerUrl
                                                            username:[[NSUserDefaults standardUserDefaults] objectForKey:DefaultsKeyUsername]
                                                            password:[[NSUserDefaults standardUserDefaults] objectForKey:DefaultsKeyPassword]];
        [self queryForNetworks];
    }
}

- (IBAction)settingsButtonClicked:(UIBarButtonItem *)sender {
    [self showSettingsViewController];
}

- (IBAction)refreshButtonClicked:(UIBarButtonItem *)sender {
    [self queryForNetworks];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    DHNetwork* network = [self.networks objectAtIndex:indexPath.row];
    cell.textLabel.text = network.name;
    cell.detailTextLabel.text = network.description;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Network Devices Segue"]) {
        NetworkDevicesViewController* networkDeviceViewController = (NetworkDevicesViewController*)segue.destinationViewController;
        networkDeviceViewController.clientService = [DHAppDelegate appDelegate].clientService;
        networkDeviceViewController.network = [self.networks objectAtIndex:[[self.tableView indexPathForCell:sender] row]];
    } else if ([segue.identifier isEqualToString:@"Settings Segue"]) {
        SettingsViewController* settingsViewController = (SettingsViewController*)segue.destinationViewController;
        settingsViewController.delegate = self;
        settingsViewController.cancelable = YES;
        settingsViewController.lastUsername = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultsKeyUsername];
        settingsViewController.lastPassword = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultsKeyPassword];
        NSString* serverUrl = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultsKeyServerUrl];
        settingsViewController.lastServerUrl = serverUrl ? serverUrl : kServerUrl;
    }
}

#pragma mark - SettingsViewControllerDelegate

- (void)settingsViewController:(SettingsViewController *)settingsViewController
            didChangeServerURL:(NSString *)url
                      username:(NSString *)username
                      password:(NSString *)password {
    
    [[NSUserDefaults standardUserDefaults] setObject:url
                                              forKey:DefaultsKeyServerUrl];
    
    [[NSUserDefaults standardUserDefaults] setObject:username
                                              forKey:DefaultsKeyUsername];
    
    [[NSUserDefaults standardUserDefaults] setObject:password
                                              forKey:DefaultsKeyPassword];
    

    [[DHAppDelegate appDelegate] setupClientServiceWithServerUrl:url
                                                        username:username
                                                        password:password];
    
    [self queryForNetworks];
}

- (void)settingsViewControllerDidCancel:(SettingsViewController *)settingsViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)queryForNetworks {
    [[DHAppDelegate appDelegate].clientService getNetworksWithCompletion:^(NSArray* networks) {
        NSLog(@"Got networks: %@", [networks description]);
        self.networks = [networks sortedArrayUsingComparator:^NSComparisonResult(DHNetwork* network1, DHNetwork* network2) {
            return [network1.name compare:network2.name];
        }];
        [self.tableView reloadData];
        if (self.presentedViewController) {
            [self dismissViewControllerAnimated:YES
                                     completion:nil];
        }
    } failure:^(NSError *error) {
        NSLog(@"Failed to get networks: %@", [error description]);
        NSHTTPURLResponse* response = error.userInfo[DHRestfulOperationFailingUrlResponseErrorKey];
        
        if (self.presentedViewController) {
            if (response.statusCode == 401) {
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                        message:@"Failed to authenticate with these credentials."
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
            } else {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                    message:@"Failed to connect to the server."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        } else {
            if (response.statusCode == 401) {
                [self showSettingsViewController];
            } else {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                    message:@"Failed to query networks. Please, check network settings and retry."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
    }];
}

- (void)showSettingsViewController {
    [self performSegueWithIdentifier:@"Settings Segue" sender:self];
}

@end
