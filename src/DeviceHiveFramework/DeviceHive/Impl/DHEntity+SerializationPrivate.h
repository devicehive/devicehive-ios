//
//  DHEntity.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/8/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Private serialization methods
 */
@interface DHEntity(SerializationPrivate)

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary*)classDictionary;

@end
