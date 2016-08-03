//
//  SafetyBaseViewController.m
//  NYUSafety
//
//  Created by Michael Gerstenfeld on 4/11/15.
//  Copyright (c) 2015 nyu safety. All rights reserved.
//

#import "SafetyBaseViewController.h"

@implementation SafetyBaseViewController

@synthesize activeField = _activeField;

- (void)viewDidLoad {
    [super viewDidLoad];
    ((UIScrollView *)self.view).delegate = self;
    [self registerForKeyboardNotifications];
}



#pragma mark - UIScrollViewDelegate

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIScrollView *scrollView = (UIScrollView *)self.view;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect bkgndRect = _activeField.superview.frame;
    bkgndRect.size.height += kbSize.height;
    [_activeField.superview setFrame:bkgndRect];
    [scrollView setContentOffset:CGPointMake(0.0, _activeField.frame.origin.y-kbSize.height) animated:YES];
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        [scrollView scrollRectToVisible:_activeField.frame animated:YES];
    }
    
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIScrollView *scrollView = (UIScrollView *)self.view;
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_activeField resignFirstResponder];
    _activeField = nil;
}


@end
