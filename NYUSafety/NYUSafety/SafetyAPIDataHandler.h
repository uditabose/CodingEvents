//
//  SafetyAPIDataHandler.h
//  NYUSafety
//
//  Created by Michael Gerstenfeld on 4/11/15.
//  Copyright (c) 2015 nyu safety. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SafetyAPIDataDelegate <NSObject>

@required

-(void) updateDelegate;

@end

@protocol SafetyAPIDataSource <NSObject>

@required

-(NSString *) getAPIURL;
-(void) updateData:(NSDictionary *)dataDictionary;

@end

@interface SafetyAPIDataHandler : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, weak) id<SafetyAPIDataDelegate> delegate;
@property (nonatomic, weak) id<SafetyAPIDataSource> dataSource;

-(void) connectAPIForData;

@end
