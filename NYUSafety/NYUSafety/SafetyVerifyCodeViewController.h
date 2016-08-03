//
//  SafetyVerifyCodeViewController.h
//  NYUSafety
//
//  Created by Michael Gerstenfeld on 4/11/15.
//  Copyright (c) 2015 nyu safety. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SafetyBaseViewController.h"
#import "SafetyAPIDataHandler.h"

@interface SafetyVerifyCodeViewController : SafetyBaseViewController < SafetyAPIDataDelegate, SafetyAPIDataSource>

@property (strong, nonatomic) NSString *userId;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeText;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
- (IBAction)verificationButtonPressed:(id)sender;

@end
