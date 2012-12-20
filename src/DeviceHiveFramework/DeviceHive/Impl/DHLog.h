//
//  DHLog.h
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 11/13/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#ifndef DeviceHiveDevice_DHLog_h
#define DeviceHiveDevice_DHLog_h

#ifdef DH_DEBUG
#define DHLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DHLog( s, ... )
#endif

#endif
