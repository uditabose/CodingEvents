//
//  OvluViewController.m
//  Ovlu
//
//  Created by user10066 on 2/17/14.
//  Copyright (c) 2014 user10066. All rights reserved.
//

#import "OvluViewController.h"

@interface OvluViewController ()



@end

@implementation OvluViewController

@synthesize webView = _webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.webView.frame = self.view.frame;
    self.webView.center = self.view.center;
    
    NSString *webapIndexPath = [[NSBundle mainBundle] pathForResource:@"index"
                                                               ofType:@"html"
                                                          inDirectory:@"webapp"];
    NSURL *webappUrl = [NSURL fileURLWithPath:webapIndexPath];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:webappUrl];
    [self setWantsFullScreenLayout:NO];
    [_webView setDelegate:self];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSLog(@"Load request : %@", request);
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

@end
