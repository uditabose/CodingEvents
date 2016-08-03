//
//  SafetyBaseViewController.h
//  NYUSafety
//
//  Created by Michael Gerstenfeld on 4/11/15.
//  Copyright (c) 2015 nyu safety. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SafetyBaseViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) UITextField *activeField;

@end
