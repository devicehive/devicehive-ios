//
//  EMDevicesViewController.m
//  EmbeddedControl
//
//  Created by  on 11.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMDevicesViewController.h"
#import "EMNetworkMO.h"
#import "EMDeviceMO.h"
#import "EMDeviceClassMO.h"
#import "NSManagedObject+FetchRequests.h"

@interface EMDevicesViewController ()
@end

@implementation EMDevicesViewController
@synthesize network;

#pragma mark - Initialization and memory management

- (void) dealloc
{
    self.network = nil;
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.restClient getDeviceListFromNetwork:network success:nil failure:nil];
}

#pragma mark - Overriden methods

- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path fetchedResultsController:(NSFetchedResultsController *)controller
{
    EMDeviceMO *device = [controller objectAtIndexPath:path];
    cell.textLabel.text = device.name;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Class: %@\nStatus: %@", device.deviceClass.name, device.status];
}

- (NSFetchRequest*) defaultFetchRequest
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"network == %@", self.network];
    return [EMDeviceMO requestAllSortedBy:@"id" ascending:YES withPredicate:predicate];
}

#pragma mark - Segue transitions

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewControlPanel"])
    {
        if ([sender isKindOfClass:[UITableViewCell class]])
        {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            EMDeviceMO *device = [[self FRCForTableView:self.tableView] objectAtIndexPath:indexPath];
            if ([segue.destinationViewController conformsToProtocol:@protocol(EMContextPasser)])
            {
                id<EMContextPasser> cpass = (id<EMContextPasser>)segue.destinationViewController;
                cpass.persistentStorageManager = self.persistentStorageManager;
                cpass.restClient = self.restClient;
                if ([cpass respondsToSelector:@selector(setDevice:)])
                    [cpass performSelector:@selector(setDevice:) withObject:device];
            }
        }
    }
}

@end
