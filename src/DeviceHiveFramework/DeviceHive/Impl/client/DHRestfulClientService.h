//
//  DHRestfulClientService.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 11/30/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHClientService.h"
#import "DHRestfulApiClient.h"


@interface DHRestfulClientService : NSObject<DHClientService>

- (id)initWithApiClient:(id<DHRestfulApiClient>)restfulApiClient;

@end
