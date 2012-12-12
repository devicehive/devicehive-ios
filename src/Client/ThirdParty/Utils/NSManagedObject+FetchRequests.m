//
// Created with JetBrains AppCode.
// User: yvorontsov
// Date: 26.06.12
// Time: 13:53
// Copyright: DataArt
//


#import "NSManagedObject+FetchRequests.h"


@implementation NSManagedObject (FetchRequests)

+ (NSArray *) findAllInContext:(NSManagedObjectContext *)context
{
    return [self executeFetchRequest:[self requestAll] inContext:context];
}

+ (NSArray *) findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllSortedBy:sortTerm ascending:ascending];
    return [self executeFetchRequest:request inContext:context];
}

+ (NSArray *) findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllSortedBy:sortTerm
                                                ascending:ascending
                                            withPredicate:searchTerm];
    return [self executeFetchRequest:request inContext:context];
}

+ (NSArray *) findAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequest];
    [request setPredicate:searchTerm];
    return [self executeFetchRequest:request
                              inContext:context];
}

+ (id) findFirstInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequest];
    return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id) findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestFirstByAttribute:attribute withValue:searchValue];
    return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id) findFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestFirstWithPredicate:searchTerm];
    return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id) findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)property ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllSortedBy:property ascending:ascending withPredicate:searchTerm];
    return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id) findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequest];
    [request setPredicate:searchTerm];
    [request setPropertiesToFetch:attributes];
    return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id) findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context andRetrieveAttributes:(id)attributes, ...
{
    NSFetchRequest *request = [self requestAllSortedBy:sortBy
                                                ascending:ascending
                                            withPredicate:searchTerm];
    [request setPropertiesToFetch:[self propertiesNamed:attributes inContext:context]];
    return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (NSArray *) findByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllWhere:attribute isEqualTo:searchValue];
    return [self executeFetchRequest:request inContext:context];
}

+ (NSArray *) findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    NSPredicate *searchTerm = [NSPredicate predicateWithFormat:@"%K = %@", attribute, searchValue];
    NSFetchRequest *request = [self requestAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm];
    return [self executeFetchRequest:request inContext:context];
}


#pragma mark - Fetch request helpers

+ (NSFetchRequest *)createFetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    return request;
}

+ (NSFetchRequest *) requestAll
{
    return [self createFetchRequest];
}

+ (NSFetchRequest *) requestAllWithPredicate:(NSPredicate *)searchTerm
{
    NSFetchRequest *request = [self createFetchRequest];
    request.predicate = searchTerm;
    return request;
}

+ (NSFetchRequest *) requestAllWhere:(NSString *)property isEqualTo:(id)value
{
    NSFetchRequest *request = [self createFetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"%K = %@", property, value];
    return request;
}

+ (NSFetchRequest *) requestFirstWithPredicate:(NSPredicate *)searchTerm
{
    NSFetchRequest *request = [self createFetchRequest];
    request.predicate = searchTerm;
    request.fetchLimit = 1;
    return request;
}

+ (NSFetchRequest *) requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue
{
    NSFetchRequest *request = [self requestAllWhere:attribute isEqualTo:searchValue];
    request.fetchLimit = 1;
    return request;
}

+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending
{
    NSFetchRequest *request = [self requestAll];
    /*NSSortDescriptor *sortBy = [[NSSortDescriptor alloc] initWithKey:sortTerm ascending:ascending];
    [request setSortDescriptors:[NSArray arrayWithObject:sortBy]];
     */
    
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    NSArray* sortKeys = [sortTerm componentsSeparatedByString:@","];
    for (NSString* sortKey in sortKeys)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
        [sortDescriptors addObject:sortDescriptor];
    }
    [request setSortDescriptors:sortDescriptors];
    
    return request;
}

+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm
{
    NSFetchRequest *request = [self requestAll];
    [request setPredicate:searchTerm];
    //[request setFetchBatchSize:[self MR_defaultBatchSize]];
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    NSArray* sortKeys = [sortTerm componentsSeparatedByString:@","];
    for (NSString* sortKey in sortKeys)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
        [sortDescriptors addObject:sortDescriptor];
    }
    [request setSortDescriptors:sortDescriptors];
    return request;
}

+ (NSArray *) executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
    __block NSArray *results = nil;
    [context performBlockAndWait:^{
        NSError *error = nil;
        results = [context executeFetchRequest:request error:&error];
        if (error)
            ALog(@"Fetch for %@ failed: %@", NSStringFromClass([self class]), error.localizedDescription);
    }];
	return results;
}

+ (id) executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
	[request setFetchLimit:1];

	NSArray *results = [self executeFetchRequest:request inContext:context];
	if ([results count] == 0)
		return nil;
	return [results objectAtIndex:0];
}

+ (NSArray *) sortAscending:(BOOL)ascending attributes:(NSArray *)attributesToSortBy
{
	NSMutableArray *attributes = [NSMutableArray array];
    for (NSString *attributeName in attributesToSortBy)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attributeName ascending:ascending];
        [attributes addObject:sortDescriptor];
    }

	return attributes;
}

+ (NSArray *) ascendingSortDescriptors:(NSArray *)attributesToSortBy
{
	return [self sortAscending:YES attributes:attributesToSortBy];
}

+ (NSArray *) descendingSortDescriptors:(NSArray *)attributesToSortBy
{
	return [self sortAscending:NO attributes:attributesToSortBy];
}

+ (id) createInContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
            inManagedObjectContext:context];
}

+ (NSEntityDescription *) entityDescriptionInContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
}

+ (NSArray *) propertiesNamed:(NSArray *)properties inContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *description = [self entityDescriptionInContext:context];
    NSMutableArray *propertiesWanted = [NSMutableArray array];
    if (properties)
    {
        NSDictionary *propDict = [description propertiesByName];

        for (NSString *propertyName in properties)
        {
            NSPropertyDescription *property = [propDict objectForKey:propertyName];
            if (property)
                [propertiesWanted addObject:property];
            else
                DLog(@"Property '%@' not found in %u properties for %@", propertyName, [propDict count], NSStringFromClass(self));
        }
    }
    return propertiesWanted;
}

@end