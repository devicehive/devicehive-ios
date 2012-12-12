//
//  EMNetworksViewController.m
//  EmbeddedControl
//
//  Created by  on 11.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMNetworksViewController.h"
#import "EMNetworkMO.h"
#import "NSManagedObject+FetchRequests.h"

@implementation EMNetworksViewController

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.restClient getNetworkList:^{} failure:^(NSError *error){}];
}

#pragma mark - Overriden methods

- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path fetchedResultsController:(NSFetchedResultsController *)controller
{
    EMNetworkMO *network = [controller objectAtIndexPath:path];
    cell.textLabel.text = network.name;
    cell.detailTextLabel.text = network.netwDescription;
}

- (NSFetchRequest*) defaultFetchRequest
{
    return [EMNetworkMO requestAllSortedBy:@"id" ascending:YES];
}

#pragma mark - Segue transitioning

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewDevices"])
    {
        if ([sender isKindOfClass:[UITableViewCell class]])
        {
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:sender];
            EMNetworkMO *network = [[self FRCForTableView:self.tableView] objectAtIndexPath:cellIndexPath];
            if ([segue.destinationViewController conformsToProtocol:@protocol(EMContextPasser)])
            {
                id<EMContextPasser> cpasser = (id<EMContextPasser>)segue.destinationViewController;
                cpasser.persistentStorageManager = self.persistentStorageManager;
                cpasser.restClient = self.restClient;
                if ([cpasser respondsToSelector:@selector(setNetwork:)])
                    [cpasser performSelector:@selector(setNetwork:) withObject:network];
            }
        }
    }
}

@end
