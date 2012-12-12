//
//  EMDevicesViewController.h
//  EmbeddedControl
//
//  Created by  on 11.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMFetchedTableViewController.h"

@class EMNetworkMO;

@interface EMDevicesViewController : EMFetchedTableViewController
@property (nonatomic, strong) EMNetworkMO *network;
@end
