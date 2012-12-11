//
//  DHAppDelegate.m
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 10/15/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "SampleDeviceAppDelegate.h"
#import "Configuration.h"
#import "SampleDevice.h"
#import "DHDeviceServices.h"

@implementation SampleDeviceAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");
    id<DHDeviceService> deviceService = [DHDeviceServices restfulDeviceServiceWithUrl:[NSURL URLWithString:kServerUrl]];
    
    self.device = [[SampleDevice alloc] initWithDeviceService:deviceService];
    
    [self registerDevice:self.device];
    
    UIViewController* rootViewController = nil;
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navCtl = (UINavigationController*)_window.rootViewController;
        rootViewController = [navCtl.viewControllers objectAtIndex:0];
    } else {
        rootViewController = self.window.rootViewController;
    }
    if ([rootViewController respondsToSelector:@selector(setDevice:)]) {
        [rootViewController performSelector:@selector(setDevice:) withObject:self.device];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive");
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
    if (self.device.isRegistered && self.device.isProcessingCommands) {
        [self.device stopProcessingCommands];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    if (self.device.isRegistered && !self.device.isProcessingCommands) {
        [self.device beginProcessingCommands];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)registerDevice:(DHDevice*)device {
    [device registerDeviceWithSuccess:^(id response) {
        NSLog(@"Successfully registered device");
        [device beginProcessingCommands];
    } failure:^(NSError *error) {
        // retry
        [self registerDevice:device];
    }];
}

@end
