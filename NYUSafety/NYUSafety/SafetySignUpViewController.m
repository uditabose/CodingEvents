//
//  SafetySignUpViewController.m
//  NYUSafety
//
//  Created by Michael Gerstenfeld on 4/11/15.
//  Copyright (c) 2015 nyu safety. All rights reserved.
//

#import "SafetySignUpViewController.h"
#import "SafetyVerifyCodeViewController.h"

@interface SafetySignUpViewController()

@property (nonatomic, strong) NSDictionary *signUpData;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation SafetySignUpViewController

@synthesize emailText = _emailText;
@synthesize nameText = _nameText;
@synthesize phoneText = _phoneText;
@synthesize passwordText = _passwordText;
@synthesize signUpButton = _signUpButton;

@synthesize signUpData = _signUpData;
@synthesize activityView = _activityView;
@synthesize alertView = _alertView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _passwordText.secureTextEntry = YES;
    _emailText.delegate = self;
    _passwordText.delegate = self;
    _phoneText.delegate = self;
    _nameText.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)signUpButtonPressed:(id)sender {
    NSLog(@"SafetySignUpViewController :: signUpButtonPressed :: start");
    NSString *email = _emailText.text;
    if (![email containsString:@"nyu.edu"]) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"Sign up Error" message:@"NYU email mandatory"
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
    SafetyAPIDataHandler *signUpDataHandler = [[SafetyAPIDataHandler alloc] init];
    signUpDataHandler.delegate = self;
    signUpDataHandler.dataSource = self;
    [signUpDataHandler connectAPIForData];
}
// handling the segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"signUpToCode"]) {
        SafetyVerifyCodeViewController *verifyViewController = (SafetyVerifyCodeViewController *)[segue destinationViewController];
        verifyViewController.userId = _emailText.text;
        [self.view resignFirstResponder];
        NSLog(@"Sign up successful, signing user up!");
    }
}

#pragma mark - SafetyAPIDataDelegate

-(void) updateDelegate {
    NSLog(@"SafetySignUpViewController :: updateDelegate :: start");
    
    // remove activity view
    if (_activityView != nil) {
        [_activityView stopAnimating];
        [_activityView removeFromSuperview];
        _activityView = nil;
    }
    
    // something went wrong
    if (_signUpData == nil || [[_signUpData valueForKey:@"code"] isEqualToString:@"0"]) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"Sign up Error" message:@"Bad user name/password"
                                               delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        _alertView.frame = CGRectMake(0, 0, 120.0, 120.0);
        _alertView.center = self.view.center;
        [self.view addSubview:_alertView];
        [_alertView show];
    } else {
        // call the segue
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"signUpToCode" sender:self];
        });
    }
    
}


#pragma mark - SafetyAPIDataSource

- (NSString *)getAPIURL {
    // hacksafety.elasticbeanstalk.com/public/index.php/adduser/userid/username/password/phone
    return [NSString stringWithFormat:@"http://hacksafety.elasticbeanstalk.com/public/index.php/adduser/%@/%@/%@/%@",
            _emailText.text, _nameText.text, _passwordText.text, _phoneText.text];
}

-(void)updateData:(NSDictionary *)dataDictionary {
    _signUpData = dataDictionary;
}

@end
