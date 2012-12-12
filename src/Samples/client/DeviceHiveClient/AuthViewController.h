//
//  AuthViewController.h
//  DeviceHiveClientSample
//
//  Created by Kiselev Maxim on 12/11/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuthViewControllerDelegate;

@interface AuthViewController : UIViewController

@property (nonatomic, weak) id<AuthViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString* lastUsername;
@property (nonatomic, strong) NSString* lastPassword;

@property (nonatomic) BOOL cancelable;

@end


@protocol AuthViewControllerDelegate <NSObject>

- (void)authViewController:(AuthViewController *)authViewController
         didObtainUsername:(NSString *)username
                  password:(NSString *)password;

- (void)authViewControllerDidCancel:(AuthViewController *)authViewController;

@end