//
//  EMPersistentStorageManager.h
//  EmbeddedControl
//
//  Created by  on 11.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Manages application's CoreData stack and file system access
 
 Client application should use instances of `NSFetchedResultsController` class to fill table views with data and to support automatical notifications when information about devices/networks/etc is changed in persistent storage. These instances should use main managed object context provided by `EMPersistentStorageManager`.
 */
@interface EMPersistentStorageManager : NSObject

/**
 Main managed object context which is used by all other contexts. It's also widely used by instances of `NSFetchedResultsController` class.
 */
@property (nonatomic, readonly, strong) NSManagedObjectContext *mainManagedObjectContext;

/** Returns full path to application's Documents directory
 */
+ (NSString*) applicationDocumentsDirectory;

/** Saves data into the specified directory under the specified file name.
 
 Before saving, this method checks if all intermediate directories exist. If no, they're created.
 
 @param fileName File name which is used for saving
 @param directory Target directory path; if this parameter is nil, application's Documents directory will be used
 @param data File data which should be saved
 
 @return YES, if file has been saved successfully, NO otherwise
 */
+ (BOOL) saveFileNamed:(NSString *)fileName toDirectory:(NSString *)directory fileData:(NSData*)data;
@end
