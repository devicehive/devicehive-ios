//
//  EMFetchedTableViewController.m
//  EmbeddedControl
//
//  Created by Yaroslav Vorontsov on 21.11.11.
//  Copyright (c) 2011 DataArt. All rights reserved.
//

#import "EMFetchedTableViewController.h"

@implementation EMFetchedTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize tableView = _tableView;
@synthesize persistentStorageManager, restClient;

#pragma mark - View lifecycle

- (void) viewDidUnload
{
    self.fetchedResultsController = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Overriden getters

- (NSFetchedResultsController*) fetchedResultsController
{
    if (!_fetchedResultsController && self.persistentStorageManager)
    {
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self defaultFetchRequest]
                managedObjectContext:self.persistentStorageManager.mainManagedObjectContext
                  sectionNameKeyPath:[self sectionKeyPath]
                cacheName:nil];
        _fetchedResultsController.delegate = self;
        NSError *error = nil;
        if (![_fetchedResultsController performFetch:&error])
            DLog(@"Fetch failed: %@", error.localizedDescription);
    }
    return _fetchedResultsController;
}

#pragma mark - Abstract methods

- (NSFetchRequest*) defaultFetchRequest
{
    ALog(@"Override this method in subclasses");
    return nil;
}

- (NSString*) sectionKeyPath
{
    return nil;
}

- (void) configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)path fetchedResultsController:(NSFetchedResultsController*)controller
{
    ALog(@"Override this method in subclasses");
}

- (UITableView*)tableViewForFRC:(NSFetchedResultsController *)fetchedResultsController
{
    return self.tableView;
}

- (NSFetchedResultsController*) FRCForTableView:(UITableView*)tableView
{
    return self.fetchedResultsController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self FRCForTableView:tableView].sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self FRCForTableView:tableView].sections objectAtIndex:(NSUInteger) section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath fetchedResultsController:[self FRCForTableView:tableView]];
    return cell;
}

#pragma mark - NSFetchedResultsController delegate methods

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableViewForFRC:controller] beginUpdates];
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableViewForFRC:controller] endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type 
{
    UITableView *tableView = [self tableViewForFRC:controller];
    switch(type) 
    {
        case NSFetchedResultsChangeInsert:
        {
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }   
        case NSFetchedResultsChangeDelete:
        {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
    }
}

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject 
        atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type 
       newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = [self tableViewForFRC:controller];
    switch(type) 
    {
        case NSFetchedResultsChangeInsert:
        {
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                              withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath fetchedResultsController:controller];
            break;
        }
            
        case NSFetchedResultsChangeMove:
        {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationLeft];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                              withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
    }
}

@end
