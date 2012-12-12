//
// Created with JetBrains AppCode.
// User: ashaman
// Date: 28.07.12
// Time: 19:18
// Copyright: DataArt
//


#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class NSManagedObjectContext;
@class NSFetchRequest;

/** `EMBaseServiceRequest` is a base class for all requests to DeviceHive server. It injects response parsing into `AFHTTPRequestOperation`'s `setCompletionBlockWithSuccess:failure:` method. Parsing itself should be done in `parseJSON:inContext:error:`. In case there's a need to perform CoreData cleanup in background, subclasses can invoke `deleteEntitiesInContext:usingRequest:` method.
 
 ## Subclassing notes
 Subclasses can be created of `EMBaseServiceRequest` depending on individual needs. It's not recommended to override `setCompletionBlockWithSuccess:failure:` method since it contains common parsing logic.
 */
@interface EMBaseServiceRequest : AFJSONRequestOperation

/** Reference to application's main managed object context. It's needed due to creation of child context which will persist changes received from the server and push them into CoreData.
 */
@property (nonatomic, weak) NSManagedObjectContext *mainContext;

/** Abstract method which should be overridden in subclasses to support parsing and changes persistence
 
Please override this method in subclasses - otherwise an assertion will be raised. If any error occurs during parsing, please set `error` parameter and return NO.
 
 @param jsonObject Parsed JSON (`NSArray`/`NSDictionary`) which should be used for database synchronization
 @param context An instance of `NSManagedObjectContext` which is pushed into the method by request
 @param error An address of `NSError` variable which can be used to store an error which may occur during content parsing

 @return YES, if response has been successfully parsed, NO otherwise
 */
- (BOOL)parseJSON:(id)jsonObject inContext:(NSManagedObjectContext *)context error:(NSError **)error;

/** Deletes managed objects which are fetched by the specified request from persistent store.
 
 This method uses lightweight fetching since it sets request's property named `includePropertyValues` to NO and no additional fault-firing should happen.
 
 @param context An instance of `NSManagedObjectContext` used for object fetch and deletion
 @param request Fetch request which specifies the entities to be deleted
 */
- (void)deleteEntitiesInContext:(NSManagedObjectContext *)context usingRequest:(NSFetchRequest *)request;
@end