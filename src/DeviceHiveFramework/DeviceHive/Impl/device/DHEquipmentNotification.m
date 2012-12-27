//
//  DHEquipmentNotification.m
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHEquipmentNotification.h"

@implementation DHEquipmentNotification

- (id)initWithName:(NSString *)name parameters:(id)parameters {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithEquipmentCode:(NSString *)equipmentCode
                 parameters:(NSDictionary *)parameters {
    NSMutableDictionary* mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[@"equipment"] = equipmentCode;
    self = [super initWithName:@"equipment"
                    parameters:mutableParameters];
    if (self ) {
        
    }
    return self;
}

@end
