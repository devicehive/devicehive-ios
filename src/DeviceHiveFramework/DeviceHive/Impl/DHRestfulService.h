//
//  DHRestfulService.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 1/10/13.
//  Copyright (c) 2013 DataArt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHRestfulApiClient.h"
#import "DHService.h"

@interface DHRestfulService : NSObject<DHService>

@property (nonatomic, strong, readonly) id<DHRestfulApiClient> restfulApiClient;

- (id)initWithApiClient:(id<DHRestfulApiClient>)restfulApiClient;

- (void)cancelAllServiceRequests;

@end
