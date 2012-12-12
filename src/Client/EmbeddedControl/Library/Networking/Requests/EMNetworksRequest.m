//
// Created with JetBrains AppCode.
// User: ashaman
// Date: 28.07.12
// Time: 21:27
// Copyright: DataArt
//


#import "EMNetworksRequest.h"
#import "EMNetworkMO.h"
#import "NSManagedObjectContext+SaveAdditions.h"
#import "NSManagedObject+FetchRequests.h"


@implementation EMNetworksRequest
{

}

+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest
{
    return [EMBaseServiceRequest canProcessRequest:urlRequest]
            && [urlRequest.URL.lastPathComponent isEqualToString:@"network"];
}

- (EMNetworkMO *)networkForID:(NSNumber *)networkID inContext:(NSManagedObjectContext *)context
{
    EMNetworkMO *network = [EMNetworkMO findFirstByAttribute:@"id"
                                                   withValue:networkID
                                                   inContext:context];
    if (!network)
        network = [EMNetworkMO createInContext:context];
    return network;
}

- (BOOL)parseJSON:(id)jsonObject inContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    NSMutableArray *networkIDs = [NSMutableArray arrayWithCapacity:[jsonObject count]];
    for (NSDictionary *jsonNetwork in jsonObject)
    {
        EMNetworkMO *network = [self networkForID:[jsonNetwork objectForKey:@"id"] inContext:context];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:jsonNetwork];
        [dict setObject:[dict objectForKey:@"description"] forKey:@"netwDescription"];
        [dict removeObjectForKey:@"description"];
        [network setValuesForKeysWithDictionary:dict];
        [networkIDs addObject:network.id];
    }
    NSFetchRequest *request = [EMNetworkMO requestAllWithPredicate:[NSPredicate predicateWithFormat:@"NOT (id IN %@)", networkIDs]];
    [self deleteEntitiesInContext:context usingRequest:request];
    return YES;
}

@end