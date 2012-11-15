//
//  DHViewController.m
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 10/15/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DHViewController.h"
#import "Configuration.h"
#import "DHTestDevice.h"


@interface DHViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sendNotificationButton;
@property (weak, nonatomic) IBOutlet UITextField *notificationName;

@property (nonatomic, weak) IBOutlet UITextView *logTextView;

@end

@implementation DHViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(testDeviceDidReceiveCommand:)
                                                 name:DHTestDeviceDidReceiveCommandNotification
                                               object:self.device];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self test];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:DHTestDeviceDidReceiveCommandNotification
                                                  object:self.device];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testDeviceDidReceiveCommand:(NSNotification*)notification {
    NSLog(@"DHViewController:testDeviceDidReceiveCommand");
    DHCommand* command = notification.userInfo[DHTestDeviceCommandKey];
    self.logTextView.text = [NSString stringWithFormat:@"%@\n%@", self.logTextView.text, [command description]];
}

- (IBAction)sendNotificationButtonTapped:(id)sender {
    NSLog(@"Sending notification...");
    NSString* notificationName = [self.notificationName text];
    if (notificationName.length > 0) {
        [self.device sendNotification:[[DHNotification alloc] initWithName:notificationName parameters:nil]
                              success:^(id response) {
            NSLog(@"Notification has been sent");
        } failure:^(NSError *error) {
            NSLog(@"Failed to send notification with error: %@", [error description]);
        }];
    }
}

@end
