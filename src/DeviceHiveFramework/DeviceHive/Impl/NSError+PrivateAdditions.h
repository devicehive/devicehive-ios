//
//  NSError+PrivateAdditions.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 12/28/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError(PrivateAdditions)

- (id)initWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;

+ (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;

+ (id)deviceErrorWithUserInfo:(NSDictionary *)userInfo;
+ (id)equipmentErrorWithUserInfo:(NSDictionary *)userInfo;
+ (id)clientErrorWithUserInfo:(NSDictionary *)userInfo;

- (id)initWithAFNetworkingError:(NSError *)error;

+ (id)errorWithAFNetworkingError:(NSError *)error;

@end
