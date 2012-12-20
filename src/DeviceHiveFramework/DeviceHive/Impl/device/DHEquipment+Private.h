//
//  DHEquipment+Private.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/13/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "DHEquipment.h"

@interface DHEquipment (Private)

@property (nonatomic, weak, readwrite) DHDevice* device;
@property (nonatomic, strong, readonly) DHEquipmentData* equipmentData;

@end
