//
//  PercolateCoffeeImageCell.m
//  iPercolateCoffee
//
//  Created by Udita Bose on 3/23/15.
//
//

#import "PercolateCoffeeImageCell.h"

/**
 * a table view cell with an image
 */
@implementation PercolateCoffeeImageCell

@synthesize coffeNameLabel = _coffeNameLabel;
@synthesize coffeeImageView = _coffeeImageView;
@synthesize coffeeDetailText = _coffeeDetailText;

- (void)awakeFromNib {
    // Initialization code
}

/**
 * updates the cell status
 */
-(void)prepareCellForDisplay:(PercolateCoffee *)percolateCoffee {
    
    _coffeeDetailText.text = percolateCoffee.coffeeDesc;
    _coffeNameLabel.text = percolateCoffee.coffeeName;
    
    // the original images are larger, so scales it down to image view's size
    if (percolateCoffee.coffeImage != nil) {
        _coffeeImageView.image = [self scaleImage:percolateCoffee.coffeImage];
    }
}

-(UIImage *) scaleImage:(UIImage *)originalImage {
    CGFloat maxWidth = _coffeeImageView.frame.size.width;
    CGFloat maxHeight = _coffeeImageView.frame.size.height;
    
    CGFloat origWidth = originalImage.size.width;
    CGFloat origHeight = originalImage.size.height;
    
    CGFloat ratioWidth = maxWidth / origWidth;
    CGFloat ratioHeight = maxHeight / origHeight ;
    
    CGFloat aspectRatio = ratioWidth;
    if (ratioHeight < ratioWidth) {
        aspectRatio = ratioHeight;
    }

    CGSize finalSize = CGSizeApplyAffineTransform(originalImage.size, CGAffineTransformMakeScale(aspectRatio, aspectRatio));
    UIGraphicsBeginImageContextWithOptions(finalSize, YES, 0.0);
    [originalImage drawInRect:CGRectMake(CGPointZero.x, CGPointZero.y, finalSize.width, finalSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
