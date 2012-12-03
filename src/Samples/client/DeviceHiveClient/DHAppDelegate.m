//
//  DHAppDelegate.m
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 10/15/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHAppDelegate.h"
#import "Configuration.h"
#import "DHClientServices.h"
#import "DHDeviceClient.h"



@implementation DHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");
    self.clientService = [DHClientServices restfulClientServiceWithUrl:[NSURL URLWithString:kServerUrl]
                                                              username:kUsername
                                                              password:kPassword];
    
    
    UIViewController* rootViewController = nil;
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navCtl = (UINavigationController*)_window.rootViewController;
        rootViewController = [navCtl.viewControllers objectAtIndex:0];
    } else {
        rootViewController = self.window.rootViewController;
    }
    if ([rootViewController respondsToSelector:@selector(setClientService:)]) {
        [rootViewController performSelector:@selector(setClientService:) withObject:self.clientService];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
