//
//  SafetyVerifyCodeViewController.m
//  NYUSafety
//
//  Created by Michael Gerstenfeld on 4/11/15.
//  Copyright (c) 2015 nyu safety. All rights reserved.
//

#import "SafetyVerifyCodeViewController.h"
#import "SafetyDashViewController.h"

@interface SafetyVerifyCodeViewController()

@property (nonatomic, strong) NSDictionary *verifyData;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation SafetyVerifyCodeViewController

@synthesize verificationCodeText = _verificationCodeText;
@synthesize verifyButton = _verifyButton;
@synthesize userId = _userId;

@synthesize verifyData = _verifyData;
@synthesize activityView = _activityView;
@synthesize alertView = _alertView;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"codeToDash"]) {
        SafetyDashViewController *dashViewController = (SafetyDashViewController *) [segue destinationViewController];
        dashViewController.userId = _userId;
    }
}

#pragma mark - SafetyAPIDataDelegate

-(void) updateDelegate {
    NSLog(@"SafetyVerifyCodeViewController :: updateDelegate :: start");
    
    // remove activity view
    if (_activityView != nil) {
        [_activityView stopAnimating];
        [_activityView removeFromSuperview];
        _activityView = nil;
    }
    
    // something went wrong
    if (_verifyData == nil || [[_verifyData valueForKey:@"code"] isEqualToString:@"0"]) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"Sign up Error" message:@"Bad verification code"
                                               delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        _alertView.frame = CGRectMake(0, 0, 120.0, 120.0);
        _alertView.center = self.view.center;
        [self.view addSubview:_alertView];
        [_alertView show];
    } else {
        // call the segue
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"codeToDash" sender:self];
        });
    }
}


#pragma mark - SafetyAPIDataSource

- (NSString *)getAPIURL {
    // hacksafety.elasticbeanstalk.com/public/index.php/verify/userid/accesscode
    return [NSString stringWithFormat:@"http://hacksafety.elasticbeanstalk.com/public/index.php/verify/%@/%@", _userId, _verificationCodeText.text];
}

-(void)updateData:(NSDictionary *)dataDictionary {
    _verifyData = dataDictionary;
    
}

- (IBAction)verificationButtonPressed:(id)sender {
    NSLog(@"SafetyVerifyCodeViewController :: verificationButtonPressed :: start");
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.frame = self.view.frame;
    _activityView.center = self.view.center;
    [_activityView startAnimating];
    [self.view addSubview:_activityView];
    
    NSLog(@"SafetyVerifyCodeViewController :: verificationButtonPressed :: showing an activity view indicator");
    
    NSLog(@"SafetyVerifyCodeViewController :: verificationButtonPressed :: calling the sign up api");
    SafetyAPIDataHandler *verificationDataHandler = [[SafetyAPIDataHandler alloc] init];
    verificationDataHandler.delegate = self;
    verificationDataHandler.dataSource = self;
    [verificationDataHandler connectAPIForData];

}
@end
