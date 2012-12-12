//
//  NSManagedObjectContext+SaveAdditions.h
//  EmbeddedControl
//
//  Created by Yaroslav Vorontsov on 02.11.11.
//  Copyright (c) 2011 DataArt. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (SaveAdditions)
- (void) enableUndo;
- (void) saveChanges;
- (void) disableUndo;
@end
