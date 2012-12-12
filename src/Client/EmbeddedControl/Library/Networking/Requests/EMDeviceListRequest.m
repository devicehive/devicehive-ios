//
// Created with JetBrains AppCode.
// User: ashaman
// Date: 28.07.12
// Time: 22:30
// Copyright: DataArt
//


#import "EMDeviceListRequest.h"
#import "EMNetworkMO.h"
#import "NSManagedObject+FetchRequests.h"
#import "EMDeviceMO.h"
#import "EMDeviceClassMO.h"


@implementation EMDeviceListRequest
{
    NSNumber *_networkID;
}
@synthesize networkID = _networkID;

- (void)dealloc
{
    self.networkID = nil;
}

+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest
{
    NSUInteger componentIndex = urlRequest.URL.pathComponents.count - 2;
    return [EMBaseServiceRequest canProcessRequest:urlRequest]
            && [[urlRequest.URL.pathComponents objectAtIndex:componentIndex] isEqualToString:@"network"];
}


- (BOOL)parseJSON:(id)jsonObject inContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    EMNetworkMO *network = [EMNetworkMO findFirstByAttribute:@"id" withValue:_networkID inContext:context];
    NSArray *jsonDevices = [jsonObject objectForKey:@"devices"];
    NSMutableArray *deviceIDs = [NSMutableArray arrayWithCapacity:jsonDevices.count];
    for (NSDictionary *jsonDevice in jsonDevices)
    {
        EMDeviceMO *device = [self deviceWithID:[jsonDevice objectForKey:@"id"] network:network];
        device.network = network;
        NSDictionary *jsonDevClass = [jsonDevice objectForKey:@"deviceClass"];
        EMDeviceClassMO *deviceClass = [self deviceClassForID:[jsonDevClass objectForKey:@"id"] inContext:context];
        deviceClass.name = [jsonDevClass objectForKey:@"name"];
        deviceClass.version = [jsonDevClass objectForKey:@"version"];
        deviceClass.id = [jsonDevClass objectForKey:@"id"];
        device.deviceClass = deviceClass;
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:jsonDevice];
        [dict removeObjectForKey:@"uid"];
        [dict removeObjectForKey:@"network"];
        [dict removeObjectForKey:@"deviceClass"];
        [device setValuesForKeysWithDictionary:dict];
        [deviceIDs addObject:device.id];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"network == %@ AND NOT (id IN %@)", network, deviceIDs];
    NSFetchRequest *request = [EMDeviceMO requestAllWithPredicate:predicate];
    [self deleteEntitiesInContext:context usingRequest:request];
    return YES;
}

- (EMDeviceMO *)deviceWithID:(NSString *)deviceID network:(EMNetworkMO *)network
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", deviceID];
    EMDeviceMO *device = [[network.devices filteredSetUsingPredicate:predicate] anyObject];
    if (!device)
        device = [EMDeviceMO createInContext:network.managedObjectContext];
    return device;
}

- (EMDeviceClassMO*) deviceClassForID:(NSNumber *)classID inContext:(NSManagedObjectContext *)context
{
    EMDeviceClassMO *deviceClass = [EMDeviceClassMO findFirstByAttribute:@"id" withValue:classID inContext:context];
    if (!deviceClass)
        deviceClass = [EMDeviceClassMO createInContext:context];
    return deviceClass;
}



@end