//
//  NSError+PrivateAdditions.h
//  DeviceHiveFramework
//
//  Created by Kiselev Maxim on 12/28/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "NSError+PrivateAdditions.h"
#import "DHErrors.h"
#import "AFNetworking.h"

@implementation NSError(PrivateAdditions)

- (id)initWithCode:(NSInteger)code userInfo:(NSDictionary *)dict {
    self = [self initWithDomain:DHErrorDomain code:code userInfo:dict];
    if (self) {
        
    }
    return self;
}

- (id)initWithAFNetworkingError:(NSError *)error {
    self = [self initWithDomain:DHRestfulOperationErrorDomain
                           code:error.code
                       userInfo:[self userInfoFromAFNetworkingError:error]];
    if (self) {
        
    }
    return self;
}

+ (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)dict {
    return [[[self class] alloc] initWithCode:code userInfo:dict];
}

+ (id)deviceErrorWithUserInfo:(NSDictionary *)userInfo {
    return [self errorWithCode:DHDeviceErrorCode userInfo:userInfo];
}

+ (id)equipmentErrorWithUserInfo:(NSDictionary *)userInfo {
    return [self errorWithCode:DHEquipmentErrorCode userInfo:userInfo];
}

+ (id)clientErrorWithUserInfo:(NSDictionary *)userInfo {
    return [self errorWithCode:DHClientErrorCode userInfo:userInfo];
}

+ (id)errorWithAFNetworkingError:(NSError *)error {
    return [[[self class] alloc] initWithAFNetworkingError:error];
}

- (NSDictionary *)userInfoFromAFNetworkingError:(NSError *)error {
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    
    [userInfo setValue:error.userInfo[AFNetworkingOperationFailingURLRequestErrorKey]
                forKey:DHRestfulOperationFailingUrlRequestErrorKey];
    
    [userInfo setValue:error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey]
                forKey:DHRestfulOperationFailingUrlResponseErrorKey];
    
    [userInfo setValue:[error localizedDescription]
                forKey:NSLocalizedDescriptionKey];
    
    [userInfo setValue:[error localizedRecoverySuggestion]
                forKey:NSLocalizedRecoverySuggestionErrorKey];
    return userInfo;
}

@end
