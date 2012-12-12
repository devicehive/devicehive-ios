//
//  EMLoginViewController.m
//  EmbeddedControl
//
//  Created by Yaroslav Vorontsov on 29.08.12.
//
//

#import "EMLoginViewController.h"

@interface EMLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UISwitch *rememberCredentialsSwitch;
- (IBAction)loginTapped;
@end

@implementation EMLoginViewController
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize rememberCredentialsSwitch;

#pragma mark - Initialization and memory management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)loginTapped
{
}

@end
