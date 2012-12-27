//
//  DHRestfulDeviceService.h
//  DeviceHiveFramework
//
//  Created by Maxim Kiselev on 11/07/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHDeviceService.h"
#import "DHRestfulApiClient.h"

@interface DHRestfulDeviceService : NSObject<DHDeviceService>

- (id)initWithApiClient:(id<DHRestfulApiClient>)restfulApiClient;

@end
