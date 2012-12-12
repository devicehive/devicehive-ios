//
// Created with JetBrains AppCode.
// User: ashaman
// Date: 30.07.12
// Time: 23:10
// Copyright: ${COMPANY}
//


#import <CoreData/CoreData.h>
#import "EMNotificationsRequest.h"
#import "EMNotificationMO.h"
#import "EMDeviceMO.h"
#import "NSManagedObject+FetchRequests.h"

@implementation EMNotificationsRequest
{
    NSString *_deviceID;
}
@synthesize deviceID = _deviceID;

- (void)dealloc
{
    self.deviceID = nil;
}

+ (BOOL)canProcessRequest:(NSURLRequest *)urlRequest
{
    DLog(@"Path components: %@", urlRequest.URL.pathComponents);
    NSUInteger componentCount = urlRequest.URL.pathComponents.count;
    BOOL isLongPoll = [[urlRequest.URL.pathComponents lastObject] isEqualToString:@"poll"];
    return [EMBaseServiceRequest canProcessRequest:urlRequest]
        && [[urlRequest.URL.pathComponents objectAtIndex:componentCount-isLongPoll?4:3] isEqualToString:@"notification"]
        && [[urlRequest.URL.pathComponents objectAtIndex:componentCount-isLongPoll?2:1] isEqualToString:@"device"];
}

- (BOOL)parseJSON:(id)jsonObject inContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    EMDeviceMO *device = [EMDeviceMO findFirstByAttribute:@"id" withValue:_deviceID inContext:context];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    formatter.dateFormat = kDateTimeFormat;
    for (NSDictionary *jsonNotification in jsonObject)
    {
        id nfString = [jsonNotification objectForKey:@"notification"];
        if (![nfString isKindOfClass:[NSNull class]])
        {
            EMNotificationMO *notification = [self notificationWithID:[jsonNotification objectForKey:@"id"]
                    forDevice:device
                      context:context];
            notification.id = [jsonNotification objectForKey:@"id"];
            notification.notification = nfString;
            notification.timestamp = [formatter dateFromString:[jsonNotification objectForKey:@"timestamp"]];
            id jsonParameters = [jsonNotification objectForKey:@"parameters"];
            if ([jsonParameters isKindOfClass:[NSDictionary class]])
            {
                notification.equipmentCode = [jsonParameters objectForKey:@"equipment"];
                NSArray *keys = [jsonParameters allKeys];
                id value = nil;
                if ([keys containsObject:@"temperature"])
                    value = [jsonParameters objectForKey:@"temperature"];
                else if ([keys containsObject:@"state"])
                    value = [jsonParameters objectForKey:@"state"];
                else if ([keys containsObject:@"rate"])
                    value = [jsonParameters objectForKey:@"rate"];
                if (value)
                    notification.value = [NSNumber numberWithDouble:[value doubleValue]];
            }
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timestamp < %@ AND device == %@", [NSDate dateWithTimeIntervalSinceNow:-2*3600], device];
    NSFetchRequest *request = [EMNotificationMO requestAllWithPredicate:predicate];
    [self deleteEntitiesInContext:context usingRequest:request];
    return YES;
}

- (EMNotificationMO*) notificationWithID:(NSNumber *)id forDevice:(EMDeviceMO *)aDevice context:(NSManagedObjectContext *)context
{
    EMNotificationMO *notification = [[aDevice.notifications filteredSetUsingPredicate:
            [NSPredicate predicateWithBlock:^BOOL(EMNotificationMO *aNotification, NSDictionary *bindings) {
                return [aNotification.id isEqualToNumber:id];
            }]] anyObject];
    if (!notification)
    {
        notification = [EMNotificationMO createInContext:context];
        notification.device = aDevice;
    }
    return notification;
}


@end