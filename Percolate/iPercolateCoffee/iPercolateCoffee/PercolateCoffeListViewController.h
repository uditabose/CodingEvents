//
//  PercolateCoffeListViewController.h
//  iPercolateCoffee
//
//  Created by Udita Bose on 3/23/15.
//
//



#import <UIKit/UIKit.h>
#import "PercolateDataHandler.h"

/**
 * Main view controller for Coffee app, serves as table datasource and delegate
 * also handles all data handling delegation 
 */
@interface PercolateCoffeListViewController : UITableViewController <PercolateDataHandlerDataSource, PercolateDataHandlerProtocol>

@end

