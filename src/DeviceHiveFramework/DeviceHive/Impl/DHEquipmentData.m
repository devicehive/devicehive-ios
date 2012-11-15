//
//  DHEquipmentData.m
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/13/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHEquipment.h"
#import "DHEquipmentData.h"
#import "DHEquipmentData+Private.h"
#import "NSMutableDictionary+DHEntitySerialization.h"

@implementation DHEquipmentData

- (id)initWithName:(NSString*)name
              code:(NSString*)code
              type:(NSString*)type {
    self  = [super init];
    if (self) {
        _name = name;
        _code = code;
        _type = type;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
    return [self initWithName:dictionary[@"name"]
                         code:dictionary[@"code"]
                         type:dictionary[@"type"]];
}

- (NSDictionary *)classDictionary {
    NSMutableDictionary* resultDict = [NSMutableDictionary dictionary];
    [resultDict setObjectIfNotNull:self.name forKey:@"name"];
    [resultDict setObjectIfNotNull:self.code forKey:@"code"];
    [resultDict setObjectIfNotNull:self.type forKey:@"type"];
    return [NSDictionary dictionaryWithDictionary:resultDict];
}

+ (NSArray*)equipmentsFromArrayOfDictionaries:(NSArray*)equipmentDictArray {
    NSMutableArray* arrayOfEquipments = [NSMutableArray array];
    for (NSDictionary* equipmentDict in equipmentDictArray) {
        [arrayOfEquipments addObject:[[DHEquipmentData alloc] initWithDictionary:equipmentDict]];
    }
    return [NSArray arrayWithArray:arrayOfEquipments];
}

+ (NSArray*)equipmentsAsArrayOfDictionaries:(NSArray*)equipments {
    NSMutableArray* arrayOfEquipments = [NSMutableArray array];
    for (id equipment in equipments) {
        if ([equipment isKindOfClass:[DHEquipmentData class]]) {
            [arrayOfEquipments addObject:[equipment classDictionary]];
        } else if ([equipment isKindOfClass:[DHEquipment class]]) {
            [arrayOfEquipments addObject:[[equipment equipmentData] classDictionary]];
        }
    }
    return [NSArray arrayWithArray:arrayOfEquipments];
}


@end
