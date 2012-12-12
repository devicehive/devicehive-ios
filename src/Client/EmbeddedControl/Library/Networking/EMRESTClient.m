//
//  EMRESTClient.m
//  EmbeddedControl
//
//  Created by  on 11.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMRESTClient.h"
#import "AFJSONRequestOperation.h"
#import "EMPersistentStorageManager.h"
#import "EMNetworkMO.h"
#import "EMDeviceMO.h"
#import "EMDeviceClassMO.h"
#import "EMNotificationMO.h"

#import "EMNetworksRequest.h"
#import "EMDeviceListRequest.h"
#import "EMDeviceClassRequest.h"
#import "EMNotificationsRequest.h"

@interface EMRESTClient()
{
    EMPersistentStorageManager *_persistentStorageManager;
}
@property (nonatomic, strong, readwrite) EMPersistentStorageManager *persistentStorageManager;
@end

#pragma mark - Main implementation
@implementation EMRESTClient
@synthesize persistentStorageManager = _persistentStorageManager;

#pragma mark - Initialization and memory management

- (id)initWithBaseURL:(NSURL *)url
{
    if ((self = [super initWithBaseURL:url]))
    {
        self.stringEncoding = NSUTF8StringEncoding;
        self.parameterEncoding = AFJSONParameterEncoding;
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self registerHTTPOperationClass:[EMNetworksRequest class]];
        [self registerHTTPOperationClass:[EMDeviceListRequest class]];
        [self registerHTTPOperationClass:[EMDeviceClassRequest class]];
        [self registerHTTPOperationClass:[EMNotificationsRequest class]];
        self.persistentStorageManager = [[EMPersistentStorageManager alloc] init];
    }
    return self;
}

- (void) dealloc
{
    self.persistentStorageManager = nil;
}

#pragma mark - Overridden methods

- (void)enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation
{
    if ([operation isKindOfClass:[EMBaseServiceRequest class]])
        ((EMBaseServiceRequest *)operation).mainContext = _persistentStorageManager.mainManagedObjectContext;
    DLog(@"Launching %@: full request URL is %@", NSStringFromClass([operation class]), operation.request.URL.absoluteString);
    [super enqueueHTTPRequestOperation:operation];
}

- (void) requestPath:(NSString *)path
              method:(NSString *)method
          parameters:(NSDictionary *)parameters
  configurationBlock:(void (^)(AFHTTPRequestOperation *operation))configurationBlock
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [self requestWithMethod:method path:path parameters:parameters];
    AFHTTPRequestOperation *requestOperation = [self HTTPRequestOperationWithRequest:request
                                                                             success:success
                                                                             failure:failure];
    if (configurationBlock)
        configurationBlock(requestOperation);
    [self enqueueHTTPRequestOperation:requestOperation];
}

#pragma mark - REST methods

- (void) getNetworkList:(RequestCompletionBlock)success failure:(RequestFailureBlock)failure
{
    [self requestPath:@"network"
               method:@"GET"
           parameters:nil
   configurationBlock:nil
              success:^void(AFHTTPRequestOperation *operation, id responseObject){
                  if (success)
                      success();
              }
              failure:^void(AFHTTPRequestOperation *operation, NSError *error){
                  if (failure)
                      failure(error);
              }];
}

- (void) getDeviceListFromNetwork:(EMNetworkMO*)network 
                          success:(RequestCompletionBlock)success
                          failure:(RequestFailureBlock)failure
{
    [self requestPath:[NSString stringWithFormat:@"network/%d", network.id.integerValue]
               method:@"GET"
           parameters:nil
   configurationBlock:^void(AFHTTPRequestOperation *operation){
       ((EMDeviceListRequest *)operation).networkID = network.id;
   }
              success:^void(AFHTTPRequestOperation *operation, id responseObject){
                  if (success)
                      success();
              }
              failure:^void(AFHTTPRequestOperation *operation, NSError *error){
                  if (failure)
                      failure(error);
              }];
}

- (void) updateDeviceState:(EMDeviceMO*)device success:(RequestCompletionBlock)success failure:(RequestFailureBlock)failure
{
    [self updateDeviceClass:device.deviceClass 
                    success:^{
                        [self getDeviceNotifications:device 
                                             success:^{
                                                 success();
                                             }
                                             failure:^(NSError *error){
                                                 DLog(@"FAIL: %@", error.localizedDescription);
                                                 failure(error);
                                             }];
                    }
                    failure:^(NSError *error){
                        DLog(@"FAIL: %@", error.localizedDescription);
                        failure(error);
                    }];
}

- (void) updateDeviceClass:(EMDeviceClassMO*)deviceClass success:(RequestCompletionBlock)success failure:(RequestFailureBlock)failure
{
    [self requestPath:[NSString stringWithFormat:@"device/class/%d", deviceClass.id.integerValue]
            method:@"GET"
        parameters:nil
configurationBlock:^void(AFHTTPRequestOperation *operation){
    ((EMDeviceClassRequest *)operation).deviceClassID = deviceClass.id;
}
           success:^void(AFHTTPRequestOperation *operation, id responseObject){
               if (success)
                   success();
           }
           failure:^void(AFHTTPRequestOperation *operation, NSError *error){
               if (failure)
                   failure(error);
           }];
}

- (void) getDeviceNotifications:(EMDeviceMO*)device success:(RequestCompletionBlock)success failure:(RequestFailureBlock)failure
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    formatter.dateFormat = kDateTimeFormat;
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:[formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-2*60*60]] 
                                                           forKey:@"start"];
    [self requestPath:[NSString stringWithFormat:@"device/%@/notification", device.id]
            method:@"GET"
        parameters:parameters
configurationBlock:^void(AFHTTPRequestOperation *operation){
    ((EMNotificationsRequest *)operation).deviceID = device.id;
}
           success:^void(AFHTTPRequestOperation *operation, id responseObject){
               if (success)
                   success();
           }
           failure:^void(AFHTTPRequestOperation *operation, NSError *error){
               if (failure)
                   failure(error);
           }];
}

- (void) deviceLongPoll:(EMDeviceMO*)device completionBlock:(PollRequestCompletionBlock)completionBlock
{
    __block BOOL continuePolling = NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    formatter.dateFormat = kDateTimeFormat;
    EMNotificationMO *lastNotification = [[device.notifications sortedArrayUsingDescriptors:
            [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES]]]
            lastObject];
    NSDate *lastNotificationDate = lastNotification?[lastNotification.timestamp dateByAddingTimeInterval:0.001]:[NSDate date];
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:[formatter stringFromDate:lastNotificationDate]
                                                           forKey:@"timestamp"];
    [self requestPath:[NSString stringWithFormat:@"device/%@/notification/poll", device.id]
               method:@"GET"
           parameters:parameters
   configurationBlock:^void(AFHTTPRequestOperation *operation){
       ((EMNotificationsRequest *)operation).deviceID = device.id;
   }
              success:^void(AFHTTPRequestOperation *operation, id responseObject){
                  completionBlock(&continuePolling, nil);
                  if (continuePolling)
                      [self deviceLongPoll:device completionBlock:completionBlock];
              }
              failure:^void(AFHTTPRequestOperation *operation, NSError *error){
                  completionBlock(&continuePolling, error);
                  if (continuePolling)
                      [self deviceLongPoll:device completionBlock:completionBlock];
              }];
}

- (void) sendCommand:(NSString*)command toDevice:(EMDeviceMO*)device 
       equimpentCode:(NSString*)equipmentCode value:(NSString*)value 
             success:(RequestCompletionBlock)success failure:(RequestFailureBlock)failure
{
    NSDictionary *cmdParameters = [NSDictionary dictionaryWithObjectsAndKeys:equipmentCode, @"equipment",
                                   value, @"state", nil];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:command, @"command",
                                cmdParameters, @"parameters", nil];
    [self postPath:[NSString stringWithFormat:@"device/%@/command", device.id]
            parameters:parameters
               success:^(AFHTTPRequestOperation *operation, id responseObject){
                   success();
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error){
                   DLog(@"FAIL: %@", error.localizedDescription);
                   failure(error);
               }];
}

- (void)stopProcessing
{

}

@end
