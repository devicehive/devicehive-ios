//
//  DHEquipmentNotification.m
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHEquipmentNotification.h"

@implementation DHEquipmentNotification

- (id)initWithName:(NSString *)name parameters:(NSDictionary *)parameters {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithEquipmentCode:(NSString*)equipmentCode
             parametersName:(NSString*)parametersName
                 parameters:(NSDictionary*)value {
    self = [super initWithName:@"equipment"
                    parameters:@{@"equipment" : equipmentCode,
                               parametersName : value}];
    if (self ) {
        
    }
    return self;
}

@end
