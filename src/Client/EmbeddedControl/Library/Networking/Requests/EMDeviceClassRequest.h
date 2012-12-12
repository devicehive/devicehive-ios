//
// Created with JetBrains AppCode.
// User: ashaman
// Date: 30.07.12
// Time: 22:05
// Copyright: ${COMPANY}
//


#import <Foundation/Foundation.h>
#import "EMBaseServiceRequest.h"


@interface EMDeviceClassRequest : EMBaseServiceRequest
@property (nonatomic, strong) NSNumber *deviceClassID;
@end