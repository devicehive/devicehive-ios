//
// Created with JetBrains AppCode.
// User: ashaman
// Date: 30.07.12
// Time: 23:10
// Copyright: ${COMPANY}
//


#import <Foundation/Foundation.h>
#import "EMBaseServiceRequest.h"


@interface EMNotificationsRequest : EMBaseServiceRequest
@property (nonatomic, copy) NSString *deviceID;
@end