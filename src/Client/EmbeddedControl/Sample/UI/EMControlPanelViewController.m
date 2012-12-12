//
//  EMControlPanelViewController.m
//  EmbeddedControl
//
//  Created by  on 11.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMControlPanelViewController.h"

#import "EMRESTClient.h"
#import "EMConstants.h"

#import "EMDeviceMO.h"
#import "EMDeviceClassMO.h"
#import "EMEquipmentMO.h"
#import "EMNotificationMO.h"
#import "NSManagedObject+FetchRequests.h"

@interface EMControlPanelViewController ()
{
    BOOL _isViewVisible;
}
@property (nonatomic, weak) IBOutlet UILabel *deviceNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceStatusLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceClassLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceClassVersionLabel;
@end

@implementation EMControlPanelViewController
@synthesize device;
@synthesize deviceNameLabel, deviceStatusLabel, deviceClassLabel, deviceClassVersionLabel;
@synthesize persistentStorageManager;
@synthesize restClient;

#pragma mark - Initialization and memory management

- (void) dealloc
{
    self.device = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.deviceNameLabel.text = self.device.name;
    self.deviceStatusLabel.text = [NSString stringWithFormat:@"Status: %@", self.device.status];
    self.deviceClassLabel.text = [NSString stringWithFormat:@"Class: %@", self.device.deviceClass.name];
    self.deviceClassVersionLabel.text = [NSString stringWithFormat:@"Class version: %@", self.device.deviceClass.version];
    [self.restClient updateDeviceState:self.device
                               success:^{
                                   [self.tableView reloadData];
                                   [self.restClient deviceLongPoll:self.device 
                                                   completionBlock:^(BOOL *continuePolling, NSError *error){
                                                       *continuePolling = _isViewVisible;
                                                       if (!error)
                                                           [self.tableView reloadData];
                                                   }];
                               }
                               failure:^(NSError *error) {
                               }];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isViewVisible = YES;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _isViewVisible = NO;
}

#pragma mark - Overridden methods

- (NSFetchRequest*) defaultFetchRequest
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY deviceClass.devices == %@", self.device];
    return [EMEquipmentMO requestAllSortedBy:@"id" ascending:YES withPredicate:predicate];
}

#pragma mark - Table view data source

- (void) configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath fetchedResultsController:(NSFetchedResultsController*)controller
{
    EMEquipmentMO *equipment = [controller objectAtIndexPath:indexPath];
    cell.textLabel.text = equipment.name;
    cell.detailTextLabel.numberOfLines = 0;
    NSMutableString *subtitleText = [NSMutableString stringWithFormat:@"Code: %@\nType: %@", equipment.code, equipment.type];
    cell.imageView.image = nil;
    cell.imageView.highlightedImage = nil;
    NSSet *sensorNotifications = [self.device.notifications filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"equipmentCode == %@", equipment.code]];
    EMNotificationMO *lastNotification = [[sensorNotifications sortedArrayUsingDescriptors:
                                           [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES]]] lastObject];
    if ([equipment.type rangeOfString:kEquipmentTypeLED].location != NSNotFound)
    {
        NSString *imageName = lastNotification.value.integerValue > 0?@"LED.png":@"LED-OFF.png";
        cell.imageView.image = [UIImage imageNamed:imageName];
    }
    else if ([equipment.type isEqualToString:kEquipmentTypeThermoSensor] && lastNotification)
        [subtitleText appendFormat:@"\nTemperature: %.2f", lastNotification.value.doubleValue];
    else if ([equipment.type isEqualToString:kEquipmentTypeStockQuote] && lastNotification)
        [subtitleText appendFormat:@"\nQuote: %.4f", lastNotification.value.doubleValue];
    cell.detailTextLabel.text = subtitleText;

}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Equipment";
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EMEquipmentMO *equipment = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([equipment.type rangeOfString:kEquipmentTypeLED].location != NSNotFound)
    {
        NSSet *sensorNotifications = [self.device.notifications filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"equipmentCode == %@", equipment.code]];
        EMNotificationMO *lastNotification = [[sensorNotifications sortedArrayUsingDescriptors:
                                               [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES]]] lastObject];
        BOOL nextLedState = YES;
        if (lastNotification)
            nextLedState = !lastNotification.value.boolValue;
        [self.restClient sendCommand:@"UpdateLedState"
                            toDevice:self.device
                       equimpentCode:equipment.code
                               value:nextLedState?@"1":@"0"
                             success:^{
                             }
                             failure:^(NSError *error){
                             }];
    }
}

@end
