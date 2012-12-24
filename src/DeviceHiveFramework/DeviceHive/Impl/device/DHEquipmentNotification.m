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

- (id)initWithEquipmentCode:(NSString*)equipmentCode
             parametersName:(NSString*)parametersName
                 parameters:(id)value {
    self = [super initWithName:@"equipment"
                    parameters:@{@"equipment" : equipmentCode,
                               parametersName : value}];
    if (self ) {
        
    }
    return self;
}

@end
