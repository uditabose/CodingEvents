//
//  PercolateDataHandler.h
//  iPercolateCoffee
//
//  Created by Udita Bose on 3/23/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PercolateCoffee.h"

/**
 * data delegate that handles view updates
 */
@protocol PercolateDataHandlerProtocol <NSObject>

@required
-(void) updateViewWithImage;
-(void) updateViewWithData;

@end

/**
 * transparent datasource for data handler to access image url and backing data array
 */
@protocol PercolateDataHandlerDataSource <NSObject>

@required
-(PercolateCoffee *) getPercolateCoffee:(NSIndexPath *)imageIndex;
-(void) addPercolateCoffee:(PercolateCoffee *)percolateCoffe;
@end

@interface PercolateDataHandler : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property id<PercolateDataHandlerProtocol> dataDelegate;
@property id<PercolateDataHandlerDataSource> dataSource;

-(void)downloadImage:(NSIndexPath *)indexPath;
-(void)downloadCoffeeData;

@end
