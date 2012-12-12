//
//  EMControlPanelViewController.h
//  EmbeddedControl
//
//  Created by  on 11.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EMFetchedTableViewController.h"

@class EMDeviceMO;

@interface EMControlPanelViewController : EMFetchedTableViewController
@property (nonatomic, strong) EMDeviceMO *device;
@end
