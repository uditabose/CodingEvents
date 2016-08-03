//
//  PercolateCoffeeImageCell.h
//  iPercolateCoffee
//
//  Created by Udita Bose on 3/23/15.
//
//

#import <UIKit/UIKit.h>
#import "PercolateCoffee.h"

@interface PercolateCoffeeImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *coffeNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coffeeImageView;
@property (weak, nonatomic) IBOutlet UITextView *coffeeDetailText;

-(void) prepareCellForDisplay:(PercolateCoffee *)percolateCoffee;

@end
