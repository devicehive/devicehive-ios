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

@interface DHAppDelegate ()

@property (nonatomic, strong, readwrite) id<DHClientService> clientService;

@end


@implementation DHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");
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

+ (DHAppDelegate*)appDelegate {
    return [UIApplication sharedApplication].delegate;
}

- (void)setupClientServiceWithServerUrl:(NSString *)url
                               username:(NSString *)username
                               password:(NSString *)password {
    
    self.clientService = [DHClientServices restfulClientServiceWithUrl:[NSURL URLWithString:url]
                                                              username:username
                                                              password:password];
}

@end
