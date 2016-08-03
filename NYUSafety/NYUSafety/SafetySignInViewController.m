//
//  SafetySignInViewController.m
//  NYUSafety
//
//  Created by Michael Gerstenfeld on 4/11/15.
//  Copyright (c) 2015 nyu safety. All rights reserved.
//

#import "SafetySignInViewController.h"
#import "SafetyDashViewController.h"

@interface SafetySignInViewController()

@property (nonatomic, strong) NSDictionary *signInData;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIAlertView *alertView;


@end

@implementation SafetySignInViewController

@synthesize emailText = _emailText;
@synthesize passwordText = _passwordText;
@synthesize signInButton = _signInButton;

@synthesize signInData = _signInData;
@synthesize activityView = _activityView;
@synthesize alertView = _alertView;

- (void)viewDidLoad {
    [super viewDidLoad];
    _passwordText.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"signInToDash"]) {
        SafetyDashViewController *dashController = (SafetyDashViewController *)[segue destinationViewController];
        dashController.userId = _emailText.text;
    }
}

#pragma mark - SafetyAPIDataDelegate

-(void) updateDelegate {
    NSLog(@"SafetySignInViewController :: updateDelegate :: start");
    
    // remove activity view
    if (_activityView != nil) {
        [_activityView stopAnimating];
        [_activityView removeFromSuperview];
        _activityView = nil;
    }
    
    // something went wrong
    if (_signInData == nil || [[_signInData valueForKey:@"code"] isEqualToString:@"0"]) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"Sign in Error" message:@"Bad user name/password"
                                               delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        _alertView.frame = CGRectMake(0, 0, 120.0, 120.0);
        _alertView.center = self.view.center;
        [self.view addSubview:_alertView];
        [_alertView show];
    } else {
        // call the segue
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"signInToDash" sender:self];
        });
    }
}


#pragma mark - SafetyAPIDataSource

- (NSString *)getAPIURL {
    // hacksafety.elasticbeanstalk.com/public/index.php/login/userid/password

    return [NSString stringWithFormat:@"http://hacksafety.elasticbeanstalk.com/public/index.php/login/%@/%@", _emailText.text, _passwordText.text];
}

-(void)updateData:(NSDictionary *)dataDictionary {
    _signInData = dataDictionary;
    
}

- (IBAction)signInButtonPressed:(id)sender {
    NSLog(@"SafetySignUpViewController :: signUpButtonPressed :: start");
    NSString *email = _emailText.text;
    if (![email containsString:@"nyu.edu"]) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"Sign in Error" message:@"NYU email mandatory"
                                               delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        _alertView.frame = CGRectMake(0, 0, 120.0, 120.0);
        _alertView.center = self.view.center;
        [self.view addSubview:_alertView];
        [_alertView show];
        return;
    }
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.frame = self.view.frame;
    _activityView.center = self.view.center;
    [_activityView startAnimating];
    [self.view addSubview:_activityView];
    
    NSLog(@"SafetySignUpViewController :: signUpButtonPressed :: showing an activity view indicator");
    
    NSLog(@"SafetySignUpViewController :: signUpButtonPressed :: calling the sign up api");
    SafetyAPIDataHandler *signInDataHandler = [[SafetyAPIDataHandler alloc] init];
    signInDataHandler.delegate = self;
    signInDataHandler.dataSource = self;
    [signInDataHandler connectAPIForData];
}
@end
