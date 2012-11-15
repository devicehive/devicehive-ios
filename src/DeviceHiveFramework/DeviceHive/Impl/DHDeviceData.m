//
//  DHDeviceData.m
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/13/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHDeviceData.h"
#import "DHEquipment.h"
#import "DHEquipment+Private.h"
#import "DHNetwork.h"
#import "DHDeviceClass.h"
#import "NSMutableDictionary+DHEntitySerialization.h"
#import "DHEntity+SerializationPrivate.h"
#import "DHEquipmentData.h"
#import "DHEquipmentData+Private.h"

@implementation DHDeviceData

- (id)initWithID:(NSString *)deviceID
             key:(NSString *)key
            name:(NSString *)name
          status:(NSString *)status
         network:(DHNetwork *)network
     deviceClass:(DHDeviceClass *)deviceClass
      equipments:(NSArray *)equipments {
    self = [super init];
    if (self) {
        _deviceID = deviceID;
        _key = key;
        _name = name;
        _status = status;
        _network = network;
        _deviceClass = deviceClass;
        _equipments = equipments;
    }
    return self;
}

- (id)initWithID:(NSString*)deviceID
             key:(NSString*)key
            name:(NSString*)name
          status:(NSString*)status
         network:(DHNetwork*)network
     deviceClass:(DHDeviceClass*)deviceClass {
    return [self initWithID:deviceID key:key name:name status:status network:network deviceClass:deviceClass];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    return [self initWithID:dictionary[@"id"]
                        key:dictionary[@"key"]
                       name:dictionary[@"name"]
                     status:dictionary[@"status"]
                    network:[[DHNetwork alloc] initWithDictionary:dictionary[@"network"]]
                deviceClass:[[DHDeviceClass alloc] initWithDictionary:dictionary[@"deviceClass"]]
                 equipments:[DHEquipmentData equipmentsFromArrayOfDictionaries:dictionary[@"equipment"]]];
}

- (NSDictionary *)classDictionary {
    NSArray* equipmentsDictArray = [DHEquipmentData equipmentsAsArrayOfDictionaries:self.equipments];
    NSDictionary* networkDict = [self.network classDictionary];
    NSDictionary* deviceClassDict = [self.deviceClass classDictionary];
    
    NSMutableDictionary* resultDict = [NSMutableDictionary dictionary];
    [resultDict setObjectIfNotNull:self.deviceID forKey:@"id"];
    [resultDict setObjectIfNotNull:self.key forKey:@"key"];
    [resultDict setObjectIfNotNull:self.name forKey:@"name"];
    [resultDict setObjectIfNotNull:self.status forKey:@"status"];
    [resultDict setObjectIfNotNull:networkDict forKey:@"network"];
    [resultDict setObjectIfNotNull:deviceClassDict forKey:@"deviceClass"];
    [resultDict setObjectIfNotNull:equipmentsDictArray forKey:@"equipment"];
    return [NSDictionary dictionaryWithDictionary:resultDict];
}


@end
