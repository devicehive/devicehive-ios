//
//  EMContextPasser.h
//  EmbeddedControl
//
//  Created by  on 11.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMPersistentStorageManager.h"
#import "EMRESTClient.h"

@protocol EMContextPasser <NSObject>
@property (nonatomic, weak) EMPersistentStorageManager *persistentStorageManager;
@property (nonatomic, weak) EMRESTClient *restClient;
@end
