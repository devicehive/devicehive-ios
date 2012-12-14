//
//  ParametersViewController.m
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 12/14/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "ParametersViewController.h"

@interface ParametersViewController ()

@property (nonatomic, weak) IBOutlet UINavigationBar* navigationBar;

@property (nonatomic, strong) NSArray* parameterKeys;

@end

@implementation ParametersViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Parameters"];
    item.hidesBackButton = YES;
    item.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                            target:self
                                                                            action:@selector(editButtonClicked:)],
                              [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(addButtonClicked:)]
    ];
    item.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneButtonClicked:)];
    [self.navigationBar pushNavigationItem:item animated:NO];
    
}

- (IBAction)doneButtonClicked:(UIBarButtonItem *)sender {
    [self.delegate parametersViewController:self
                 didFinishEditingParameters:self.parameters];
}

- (IBAction)addButtonClicked:(id)sender {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"New parameter"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"OK", nil];
    
    [av setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    
    [[av textFieldAtIndex:1] setSecureTextEntry:NO];
    [[av textFieldAtIndex:0] setPlaceholder:@"Name"];
    [[av textFieldAtIndex:1] setPlaceholder:@"Value"];
    [av show];
}

- (void)editButtonClicked:(id)sender {
    if (!self.editing) {
        self.navigationBar.topItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                                         target:self
                                                                                                         action:@selector(editButtonClicked:)],
        ];
    } else {
        self.navigationBar.topItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                                         target:self
                                                                                                         action:@selector(editButtonClicked:)],
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(addButtonClicked:)]
        ];
        
    }
    [self setEditing:!self.editing animated:YES];
}

- (void)setParameters:(NSDictionary *)parameters {
    if (_parameters != parameters) {
        _parameters = parameters;
        self.parameterKeys = [_parameters keysSortedByValueUsingSelector:@selector(compare:)];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.parameters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Parameter Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString* parameterName = self.parameterKeys[indexPath.row];
    NSString* parameterValue = self.parameters[parameterName];
    cell.textLabel.text = parameterName;
    cell.detailTextLabel.text = parameterValue;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
         NSMutableDictionary* newParams = [NSMutableDictionary dictionaryWithDictionary:self.parameters];
        [newParams removeObjectForKey:self.parameterKeys[indexPath.row]];
        self.parameters = newParams;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - Table view delegate



#pragma mark - Table view UIAlertDelegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        // no op
    } else {
        NSString* paramName = [alertView textFieldAtIndex:0].text;
        NSString* paramValue = [alertView textFieldAtIndex:1].text;
        if (paramName.length && paramValue.length) {
            NSMutableDictionary* newParams = [NSMutableDictionary dictionaryWithDictionary:self.parameters];
            [newParams setObject:paramValue forKey:paramName];
            self.parameters = newParams;
            [self.tableView reloadData];
        }
    }
}



@end
