//
//  DHAppDelegate.m
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 10/15/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHAppDelegate.h"
#import "Configuration.h"
#import "DHTestDevice.h"
#import "DHDeviceServices.h"

@implementation DHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");
    id<DHDeviceService> deviceService = [DHDeviceServices deviceServiceForProtocol:DHDeviceServiceProcotolRestful
                                                                        serviceUrl:[NSURL URLWithString:kServerUrl]];
    
    self.device = [[DHTestDevice alloc] initWithDeviceService:deviceService];
    
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
        //[self.deviceService stopReceivingCommands];
        [self.device stopProcessingCommands];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    if (self.device.isRegistered && !self.device.isProcessingCommands) {
        //[self.deviceService beginReceivingCommands];
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
        //[self.deviceService beginReceivingCommands];
        [device beginProcessingCommands];
    } failure:^(NSError *error) {
        // retry
        [self registerDevice:device];
    }];
}

@end
