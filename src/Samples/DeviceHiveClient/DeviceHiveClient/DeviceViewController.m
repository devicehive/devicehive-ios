//
//  DHViewController.m
//  DeviceHiveDevice
//
//  Created by Kiselev Maxim on 10/15/12.
//  Copyright (c) 2012 DataArt. All rights reserved.
//

#import "DeviceViewController.h"
#import "Configuration.h"
#import "DHDeviceData.h"
#import "DHDeviceClient.h"
#import "DHCommand.h"


@interface DeviceViewController () <DHDeviceClientDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendCommandButton;
@property (weak, nonatomic) IBOutlet UITextField *commandName;

@property (nonatomic, weak) IBOutlet UITextView *logTextView;

@property (nonatomic, strong) DHDeviceClient* deviceClient;

@end

@implementation DeviceViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.deviceData.name;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.deviceClient beginReceivingNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.deviceClient stopReceivingNotifications];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.deviceClient.delegate = nil;
}

- (void)setDeviceData:(DHDeviceData *)deviceData {
    if (_deviceData != deviceData) {
        _deviceData = deviceData;
        [self.deviceClient stopReceivingNotifications];
        self.deviceClient = [[DHDeviceClient alloc] initWithDevice:_deviceData
                                                     clientService:self.clientService];
        self.deviceClient.delegate = self;
    }
}

- (IBAction)sendCommand:(UIButton *)sender {
    NSString* commandName = self.commandName.text;
    if (!commandName || !commandName.length) {
        commandName = @"TestCommand";
    }
    
    DHCommand* command = [[DHCommand alloc] initWithName:commandName parameters:nil];
    [self.deviceClient sendCommand:command success:^(id response) {
        NSLog(@"Command has been sent");
    } failure:^(NSError *error) {
        NSLog(@"Failed to send command: %@", [error description]);
    }];
}

#pragma mark - DHDeviceClientDelegate

- (void)deviceClient:(DHDeviceClient *)client didReceiveNotification:(DHNotification *)notification {
    NSLog(@"deviceClient:didReceiveNotification:(%@)", [notification description]);
    self.logTextView.text = [NSString stringWithFormat:@"%@\n%@", self.logTextView.text, [notification description]];
}

- (void)deviceClientWillBeginReceivingNotifications:(DHDeviceClient *)client {
    NSLog(@"deviceClientWillBeginReceivingNotifications");
}

- (void)deviceClientDidStopReceivingNotifications:(DHDeviceClient *)client {
    NSLog(@"ddeviceClientDidStopReceivingNotifications");
}

- (void)deviceClient:(DHDeviceClient *)client willSendCommand:(DHCommand *)command {
    NSLog(@"deviceClient:willSendCommand:(%@)", command.name);
}

- (void)deviceClient:(DHDeviceClient *)client didSendCommand:(DHCommand *)command {
    NSLog(@"deviceClient:didSendCommand:(%@)", command.name);
}

- (void)deviceClient:(DHDeviceClient *)client didFailSendCommand:(DHCommand *)command withError:(NSError *)error {
    NSLog(@"deviceClient:didFailSendCommand:(%@):withError:(%@)", command.name, [error description]);
}


@end
