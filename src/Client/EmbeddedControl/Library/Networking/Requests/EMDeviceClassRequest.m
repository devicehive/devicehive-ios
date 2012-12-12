//
// Created with JetBrains AppCode.
// User: ashaman
// Date: 30.07.12
// Time: 22:05
// Copyright: ${COMPANY}
//


#import "EMDeviceClassRequest.h"
#import "EMDeviceClassMO.h"
#import "NSManagedObject+FetchRequests.h"
#import "EMEquipmentMO.h"


@implementation EMDeviceClassRequest
{
    NSNumber *_deviceClassID;
}
@synthesize deviceClassID = _deviceClassID;

- (void)dealloc
{
    self.deviceClassID = nil;
}

+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest
{
    NSUInteger componentCount = urlRequest.URL.pathComponents.count;
    return [EMBaseServiceRequest canProcessRequest:urlRequest]
        && [[urlRequest.URL.pathComponents objectAtIndex:componentCount-3] isEqualToString:@"device"]
        && [[urlRequest.URL.pathComponents objectAtIndex:componentCount-2] isEqualToString:@"class"];
}

- (BOOL)parseJSON:(id)jsonObject inContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    EMDeviceClassMO *deviceClass = [EMDeviceClassMO findFirstByAttribute:@"id" withValue:_deviceClassID inContext:context];
    NSArray *sensors = [jsonObject objectForKey:@"equipment"];
    NSMutableArray *sensorIDs = [NSMutableArray arrayWithCapacity:sensors.count];
    for (NSDictionary *jsonSensor in sensors)
    {
        EMEquipmentMO *equipment = [self equipmentForID:[jsonSensor objectForKey:@"id"]
                deviceClass:deviceClass context:context];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:jsonSensor];
        [dict removeObjectForKey:@"deviceClass"];
        [dict removeObjectForKey:@"equipmentType"];
        [equipment setValuesForKeysWithDictionary:dict];
        [sensorIDs addObject:equipment.id];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceClass == %@ AND NOT (id IN %@)", deviceClass, sensorIDs];
    NSFetchRequest *request = [EMEquipmentMO requestAllWithPredicate:predicate];
    [self deleteEntitiesInContext:context usingRequest:request];
    return YES;
}

- (EMEquipmentMO *)equipmentForID:(NSNumber *)equipmentID deviceClass:(EMDeviceClassMO *)deviceClass context:(NSManagedObjectContext *)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceClass == %@ AND id == %d", deviceClass, [equipmentID unsignedIntegerValue]];
    EMEquipmentMO *equipment = [EMEquipmentMO findFirstWithPredicate:predicate
                                                           inContext:context];
    if (!equipment)
    {
        equipment = [EMEquipmentMO createInContext:context];
        equipment.deviceClass = deviceClass;
    }
    return equipment;
}

@end