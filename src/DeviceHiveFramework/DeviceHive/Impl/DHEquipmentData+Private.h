//
//  DHEquipment+DHEquipment_Private.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/12/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHEquipmentData.h"

@interface DHEquipmentData (Private)

+ (NSArray*)equipmentsFromArrayOfDictionaries:(NSArray*)equipmentDictArray;
+ (NSArray*)equipmentsAsArrayOfDictionaries:(NSArray*)equipments;

@end
