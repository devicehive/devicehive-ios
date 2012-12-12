//
//  NSManagedObjectContext+SaveAdditions.m
//  EmbeddedControl
//
//  Created by Yaroslav Vorontsov on 02.11.11.
//  Copyright (c) 2011 DataArt. All rights reserved.
//

#import "NSManagedObjectContext+SaveAdditions.h"

@implementation NSManagedObjectContext (SaveAdditions)

- (void) enableUndo
{
    if (self.undoManager && !self.undoManager.isUndoRegistrationEnabled)
    {
        [self processPendingChanges];
        [self.undoManager enableUndoRegistration];
    }
}

- (void) disableUndo
{
    if (self.undoManager && self.undoManager.isUndoRegistrationEnabled)
    {
        [self processPendingChanges];
        [self.undoManager disableUndoRegistration];
    }
}

- (void) saveChanges
{
    if (self.hasChanges)
    {
        NSError *error = nil;
        if (![self save:&error])
            DLog(@"Context saving failed: %@", error.localizedDescription);
    }
}

@end
