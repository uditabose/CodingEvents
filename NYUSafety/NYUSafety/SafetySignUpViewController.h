//
//  SafetySignUpViewController.h
//  NYUSafety
//
//  Created by Michael Gerstenfeld on 4/11/15.
//  Copyright (c) 2015 nyu safety. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SafetyBaseViewController.h"
#import "SafetyAPIDataHandler.h"


@interface SafetySignUpViewController : SafetyBaseViewController <SafetyAPIDataDelegate, SafetyAPIDataSource>

@property (weak, nonatomic) IBOutlet UITextField *emailText;

@property (weak, nonatomic) IBOutlet UITextField *nameText;

@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

- (IBAction)signUpButtonPressed:(id)sender;


@end
