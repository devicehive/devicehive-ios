//
//  EMFetchedTableViewController.h
//  EmbeddedControl
//
//  Created by Yaroslav Vorontsov on 21.11.11.
//  Copyright (c) 2011 DataArt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EMContextPasser.h"

@interface EMFetchedTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, EMContextPasser>
{
    __weak UITableView *_tableView;
    NSFetchedResultsController *_fetchedResultsController;
}
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
- (NSFetchRequest*) defaultFetchRequest;
- (NSString*) sectionKeyPath;
- (UITableView*) tableViewForFRC:(NSFetchedResultsController*)fetchedResultsController;
- (NSFetchedResultsController*) FRCForTableView:(UITableView*)tableView;
- (void) configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)path fetchedResultsController:(NSFetchedResultsController*)controller;
@end
