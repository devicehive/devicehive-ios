//
// Created with JetBrains AppCode.
// User: ashaman
// Date: 28.07.12
// Time: 19:18
// Copyright: DataArt
//


#import <CoreData/CoreData.h>
#import "EMBaseServiceRequest.h"

typedef void (^AFSuccessCompletionBlock)(AFHTTPRequestOperation *operation, id response);
typedef void (^AFFailureCompletionBlock)(AFHTTPRequestOperation *request, NSError *error);

@implementation EMBaseServiceRequest
{
    __weak NSManagedObjectContext *_mainContext;
}
@synthesize mainContext = _mainContext;


#pragma mark - Overridden methods

- (id)initWithRequest:(NSURLRequest *)urlRequest
{
    if ((self = [super initWithRequest:urlRequest]))
    {
        self.successCallbackQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.failureCallbackQueue = self.successCallbackQueue;
    }
    return self;
}

- (void)setCompletionBlockWithSuccess:(AFSuccessCompletionBlock)success
                              failure:(AFFailureCompletionBlock)failure
{
    EMBaseServiceRequest *__weak selfLink = self;
    [super setCompletionBlockWithSuccess:(AFSuccessCompletionBlock)^(EMBaseServiceRequest *request, id response){
        @autoreleasepool
        {
            NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            childContext.parentContext = _mainContext;
            __block BOOL parsedSuccessfully = YES;
            __block NSError *parserError = nil;
            [childContext performBlockAndWait:^{
                NSError *childCtxError = nil;
                parsedSuccessfully = [selfLink parseJSON:response inContext:childContext error:&parserError];
                if ([childContext hasChanges] && ![childContext save:&childCtxError])
                {
                    ALog(@"Context saving failed: %@\n Info: %@", childCtxError.localizedDescription, childCtxError.userInfo);
                }
                [selfLink.mainContext performBlock:^{
                    NSError *mainCtxError = nil;
                    if ([selfLink.mainContext hasChanges] && ![selfLink.mainContext save:&mainCtxError])
                    {
                        ALog(@"Context saving failed: %@\n Info: %@", mainCtxError.localizedDescription, mainCtxError.userInfo);
                    }
                }];
            }];
            if (parsedSuccessfully)
                [selfLink invokeSuccessBlock:success request:request response:response];
            else
                [selfLink invokeFailureBlock:failure request:request error:parserError];
        }
    } failure:(AFFailureCompletionBlock)^(EMBaseServiceRequest *request, NSError *error){
        [selfLink invokeFailureBlock:failure request:request error:error];
    }];
}

#pragma mark - Callback invocations

- (void)invokeFailureBlock:(AFFailureCompletionBlock)failure request:(EMBaseServiceRequest *)request error:(NSError *)error
{
    if (failure)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(request, error);
        });
    }
}

- (void)invokeSuccessBlock:(AFSuccessCompletionBlock)success request:(EMBaseServiceRequest *)request response:(id)response
{
    if (success)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            success(request, response);
        });
    }
}

#pragma mark - Methods to override

- (BOOL)parseJSON:(id)jsonObject inContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    return YES;
}

#pragma mark - Database cleaning methods

- (void) deleteEntitiesInContext:(NSManagedObjectContext *)context usingRequest:(NSFetchRequest *)request
{
    request.includesPropertyValues = NO;
    request.includesSubentities = NO;
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error)
        DLog(@"Fetching failed: %@", error.localizedDescription);
    else
    {
        for (NSManagedObject *object in results)
        {
            [context deleteObject:object];
        }
    }
}

@end