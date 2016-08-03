//
//  SafetyAPIDataHandler.m
//  NYUSafety
//
//  Created by Michael Gerstenfeld on 4/11/15.
//  Copyright (c) 2015 nyu safety. All rights reserved.
//

#import "SafetyAPIDataHandler.h"

@interface  SafetyAPIDataHandler()

@property (strong, nonatomic) NSURLSession *safetyession;

@end

@implementation SafetyAPIDataHandler

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize safetyession = _safetyession;

-(instancetype)init {
    self = [super init];
    if (self) {
        // initiates the session object
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _safetyession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    }
    return self;
}


-(void) connectAPIForData {
    if (_delegate == nil || _dataSource == nil) {
        NSLog(@"SafetyAPIDataHandler :: connectAPIForData :: Delegate or DataSource unavailable");
        return;
    }

    NSString *apiUrlString = [_dataSource getAPIURL];
    
    if (apiUrlString == nil) {
        NSLog(@"SafetyAPIDataHandler :: connectAPIForData :: Delegate or DataSource unavailable");
        
        [_dataSource updateData:nil];
        
        return;
    }
    
    NSLog(@"SafetyAPIDataHandler :: connectAPIForData ::  %@", apiUrlString);
    
    NSURL *dataDownURL = [NSURL URLWithString:apiUrlString];
    
    NSURLSessionDownloadTask *dataDownloadTask = [_safetyession downloadTaskWithURL:dataDownURL
                                                    completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            
            NSData *taskData = [NSData dataWithContentsOfURL:location];
            NSError *perror = nil;
            NSObject* responseObj = [NSJSONSerialization JSONObjectWithData:taskData options:NSJSONReadingMutableContainers error:&perror];
            if (perror == nil) {
                NSLog(@"SafetyAPIDataHandler :: connectAPIForData ::  %@", responseObj);
                
                if ([responseObj isKindOfClass:[NSArray class]]) {
                    NSArray *resArray = (NSArray *)responseObj;
                    [_dataSource updateData:[resArray objectAtIndex:0]];
                } else if ([responseObj isKindOfClass:[NSDictionary class]]) {
                    [_dataSource updateData:(NSDictionary *)responseObj];
                } else {
                    NSLog(@"SafetyAPIDataHandler :: connectAPIForData :: Response object class %@", [responseObj class]);
                }
                
            }
            
            [_delegate updateDelegate];
        }
        
    }];
    
    [dataDownloadTask setTaskDescription:@"data"];
    [dataDownloadTask resume];
    
    
}

@end
