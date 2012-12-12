//
// Created with JetBrains AppCode.
// User: ashaman
// Date: 28.07.12
// Time: 22:30
// Copyright: DataArt
//


#import <Foundation/Foundation.h>
#import "EMBaseServiceRequest.h"


@interface EMDeviceListRequest : EMBaseServiceRequest
@property (nonatomic, strong) NSNumber *networkID;
@end