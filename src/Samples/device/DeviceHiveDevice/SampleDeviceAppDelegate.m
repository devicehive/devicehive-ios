//
//  DHAppDelegate.m
//  DeviceHiveDeviceSample
//
//  Created by Kiselev Maxim on 10/15/12.
//  Copyright (c) 2012 DataArt Apps. All rights reserved.
//

#import "SampleDeviceAppDelegate.h"
#import "Constants.h"
#import "SampleDevice.h"
#import "DHDeviceServices.h"

@interface SampleDeviceAppDelegate ()

@property (nonatomic, strong, readwrite) DHDevice* device;

@end

@implementation SampleDeviceAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");
    self.device = [[SampleDevice alloc] init];
    if (!self.device.isRegistered) {
        NSString* serverUrl = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultsKeyServerUrl];
        if (!serverUrl) {
            serverUrl = kDefaultServerUrl;
            [[NSUserDefaults standardUserDefaults] setObject:serverUrl forKey:DefaultsKeyServerUrl];
        }
        [self registerDeviceWithServiceUrl:serverUrl];
    }

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
    if (self.device.isRegistered) {
        [self.device unregisterDevice];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    if (!self.device.isRegistered) {
        NSString* serverUrl = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultsKeyServerUrl];
        if (!serverUrl) {
            serverUrl = kDefaultServerUrl;
            [[NSUserDefaults standardUserDefaults] setObject:serverUrl forKey:DefaultsKeyServerUrl];
        }
        [self registerDeviceWithServiceUrl:serverUrl];
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

- (void)registerDeviceWithServiceUrl:(NSString *)deviceServiceUrl completion:(void (^)(BOOL success))completion {
    id<DHDeviceService> deviceService = [DHDeviceServices restfulDeviceServiceWithUrl:[NSURL URLWithString:deviceServiceUrl]];
    [self registerDeviceWithService:deviceService completion:completion];
}

- (void)registerDeviceWithService:(id<DHDeviceService>)deviceService completion:(void (^)(BOOL success))completion {
    [self registerDevice:self.device withDeviceService:deviceService completion:completion];
}

- (void)registerDevice:(DHDevice*)device
     withDeviceService:(id<DHDeviceService>)deviceService
            completion:(void (^)(BOOL success))completion {
    
    if (self.device.isRegistered) {
        [self.device unregisterDevice];
    }
    [device registerDeviceWithDeviceService:deviceService success:^(id response) {
        completion(YES);
    } failure:^(NSError *error) {
        NSLog(@"Failed to register device(%@) with error: %@", device.deviceData.name, [error description]);
        completion(NO);
    }];
}

- (void)registerDeviceWithServiceUrl:(NSString *)deviceServiceUrl {
    [self registerDeviceWithServiceUrl:deviceServiceUrl completion:^(BOOL success) {
        if (success) {
            NSLog(@"Successfully registered device");
            [self.device beginProcessingCommands];
        } else {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:@"Failed to register device. Check server URL and try again."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

+ (SampleDeviceAppDelegate *)sampleAppDelegate {
    return (SampleDeviceAppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
