//
//  EMAppDelegate.m
//  EmbeddedControl
//
//  Created by  on 11.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMAppDelegate.h"
#import "EMRESTClient.h"
#import "EMPersistentStorageManager.h"
#import "EMContextPasser.h"

@interface EMAppDelegate()
{
    UIWindow *_window;
    EMRESTClient *_restClient;
    EMPersistentStorageManager *_persistentStorageManager;
}
@property (nonatomic, strong) EMRESTClient *restClient;
@property (nonatomic, strong) EMPersistentStorageManager *persistentStorageManager;
@end

@implementation EMAppDelegate
@synthesize window = _window;
@synthesize restClient = _restClient;
@synthesize persistentStorageManager = _persistentStorageManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.restClient = [[EMRESTClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://ecloud.dataart.com/ecapi6/"]];
    [_restClient setAuthorizationHeaderWithUsername:@"sn" password:@"sn"];
    if ([_window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navCtl = (UINavigationController*)_window.rootViewController;
//        [navCtl performSegueWithIdentifier:@"showLoginScreen" sender:self];
        UIViewController *rootVC = [navCtl.viewControllers objectAtIndex:0];
        if ([rootVC conformsToProtocol:@protocol(EMContextPasser)])
        {
            [rootVC performSelector:@selector(setPersistentStorageManager:) withObject:_restClient.persistentStorageManager];
            [rootVC performSelector:@selector(setRestClient:) withObject:_restClient];
        }
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    __block UIBackgroundTaskIdentifier taskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^void(){
        [application endBackgroundTask:taskIdentifier];
        taskIdentifier = UIBackgroundTaskInvalid;
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [application endBackgroundTask:taskIdentifier];
        taskIdentifier = UIBackgroundTaskInvalid;
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state;
    // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive.
    // If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    self.restClient = nil;
}

@end
