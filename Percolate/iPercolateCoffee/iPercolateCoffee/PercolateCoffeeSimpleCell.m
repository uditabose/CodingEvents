//
//  PercolateCoffeeSimpleCell.m
//  iPercolateCoffee
//
//  Created by Udita Bose on 3/23/15.
//
//

#import "PercolateCoffeeSimpleCell.h"

/**
 * this table cell does not contain any image
 */
@implementation PercolateCoffeeSimpleCell

- (void)awakeFromNib {
    // Initialization code
}

/**
 * updates cells data
 */
-(void)prepareCellForDisplay:(PercolateCoffee *)percolateCoffee {
    _coffeeDetailText.text = percolateCoffee.coffeeDesc;
    _coffeNameLabel.text = percolateCoffee.coffeeName;
}

@end
