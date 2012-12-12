//
//  EMPersistentStorageManager.m
//  EmbeddedControl
//
//  Created by  on 11.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMPersistentStorageManager.h"
#import <CoreData/CoreData.h>

#import "EMNotificationMO.h"

@interface EMPersistentStorageManager()
{
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_mainManagedObjectContext;
    NSManagedObjectContext *_temporaryManagedObjectContext;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}
@property (nonatomic, readwrite, strong) NSManagedObjectContext *mainManagedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

#pragma mark - Main implementation

@implementation EMPersistentStorageManager
@synthesize mainManagedObjectContext = _mainManagedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Initialization and memory management

- (id) init
{
    if ((self = [super init]))
    {
        NSError* error = nil;
        NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"EmbeddedControl" ofType:@"momd"];
        NSURL* modelURL = [NSURL fileURLWithPath:modelPath isDirectory:NO];
        self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        NSString *storePath = [[[self class] applicationDocumentsDirectory] stringByAppendingPathComponent:@"EmbeddedControl.sqlite"];
        NSURL* storeURL = [NSURL fileURLWithPath:storePath isDirectory:NO];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:storeURL
                                                             options:options
                                                               error:&error]) 
        {
            ALog(@"Unresolved error: %@, %@", error, [error localizedDescription]);
        }
        self.mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainManagedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
        _mainManagedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    }
    return self;
}

- (void) dealloc
{
    self.mainManagedObjectContext = nil;
    self.managedObjectModel = nil;
    self.persistentStoreCoordinator = nil;
}

#pragma mark - Class methods

+ (NSString*) applicationDocumentsDirectory
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

#pragma mark - File manager functions

+ (BOOL) saveFileNamed:(NSString *)fileName toDirectory:(NSString *)directory fileData:(NSData*)data
{
    if (!directory)
        directory = [self applicationDocumentsDirectory];
    BOOL isDirectory = NO;
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDirectory])
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:directory 
                                       withIntermediateDirectories:YES attributes:nil error:&error])
        {
            DLog(@"Creation of directory failed: %@", error.localizedDescription);
            return NO;
        }
    }
    else if (!isDirectory)
        return NO;
    if (![[NSFileManager defaultManager] createFileAtPath:[directory stringByAppendingPathComponent:fileName] 
                                                 contents:data attributes:nil])
    {
        DLog(@"File saving failed");
        return NO;
    }
    return YES;
}

@end
