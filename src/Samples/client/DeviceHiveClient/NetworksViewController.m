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
#import "AuthViewController.h"
#import "DHAppDelegate.h"
#import "DHClientServices.h"
#import "Configuration.h"

NSString* const DefaultsKeyUsername = @"Username";
NSString* const DefaultsKeyPassword = @"Password";

@interface NetworksViewController () <AuthViewControllerDelegate>

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
        [self performSelector:@selector(showAuthViewController) withObject:nil afterDelay:0.1];
    } else {
        [[DHAppDelegate appDelegate] setupClientServiceWithUsername:[[NSUserDefaults standardUserDefaults] objectForKey:DefaultsKeyUsername]
                                                           password:[[NSUserDefaults standardUserDefaults] objectForKey:DefaultsKeyPassword]];
        [self queryForNetworks];
    }
}

- (IBAction)authButtonClicked:(UIBarButtonItem *)sender {
    [self showAuthViewController];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
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
    } else if ([segue.identifier isEqualToString:@"Auth Segue"]) {
        AuthViewController* authViewController = (AuthViewController*)segue.destinationViewController;
        authViewController.delegate = self;
        authViewController.cancelable = YES;
        authViewController.lastUsername = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultsKeyUsername];
        authViewController.lastPassword = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultsKeyPassword];
    }
}

#pragma mark - AuthViewControllerDelegate

- (void)authViewController:(AuthViewController *)authViewController
         didObtainUsername:(NSString *)username
                  password:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setObject:username
                                              forKey:DefaultsKeyUsername];
    
    [[NSUserDefaults standardUserDefaults] setObject:password
                                              forKey:DefaultsKeyPassword];
    

    [[DHAppDelegate appDelegate] setupClientServiceWithUsername:username
                                                       password:password];
    
    [self queryForNetworks];
}

- (void)authViewControllerDidCancel:(AuthViewController *)authViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)queryForNetworks {
    [[DHAppDelegate appDelegate].clientService getNetworksWithCompletion:^(NSArray* networks) {
        NSLog(@"Got networks: %@", [networks description]);
        self.networks = networks;
        [self.tableView reloadData];
        if (self.presentedViewController) {
            [self dismissViewControllerAnimated:YES
                                     completion:nil];
        }
    } failure:^(NSError *error) {
        NSLog(@"Failed to get networks: %@", [error description]);
        NSHTTPURLResponse* response = error.userInfo[DHRestfulOperationFailingUrlResponseErrorKey];
        // auth failed
        if (response.statusCode == 401) {
            if (self.presentedViewController) {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                    message:@"Failed to aythenticate with these credentials."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            } else {
                [self showAuthViewController];
            }
        }
    }];
}

- (void)showAuthViewController {
    [self performSegueWithIdentifier:@"Auth Segue" sender:self];
}

@end
