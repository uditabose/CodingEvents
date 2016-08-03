//
//  PercolateDataHandler.m
//  iPercolateCoffee
//
//  Created by Udita Bose on 3/23/15.
//
//

#import "PercolateDataHandler.h"
#import "PercolateCoffeListViewController.h"

/**
 * handles data connection and json parsing
 */
@interface PercolateDataHandler()

@property (weak, nonatomic) PercolateCoffee *percolateCoffee;
@property (strong, nonatomic) NSURLSession *percolateSession;
@property (strong, nonatomic) NSMutableArray *percolateDataArray;
@property (weak, nonatomic) PercolateCoffeListViewController *parentController;

@end

@implementation PercolateDataHandler

@synthesize percolateSession = _percolateSession;
@synthesize dataSource = _dataSource;
@synthesize dataDelegate = _dataDelegate;


-(instancetype)init {
    self = [super init];
    if (self) {
        // initiates the session object
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _percolateSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    }
    return self;
}

/**
 * downloads an image for the row at indexPath
 */
-(void)downloadImage:(NSIndexPath *)indexPath {
    
    __block PercolateCoffee * percolateCoffee = [_dataSource getPercolateCoffee:indexPath];
    
    if (percolateCoffee.coffeeImageURL == nil || [percolateCoffee.coffeeImageURL isEqualToString:@""]) {
        NSLog(@"No image to download : %@", indexPath);
        return;
    }
    NSLog(@"coffeeImageURL %@", percolateCoffee.coffeeImageURL);
    NSURL *imageDownURL = [NSURL URLWithString:percolateCoffee.coffeeImageURL];
    
    NSURLSessionDownloadTask *imageDownloadTask = [_percolateSession downloadTaskWithURL:imageDownURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSData *taskData = [NSData dataWithContentsOfURL:location];
            percolateCoffee.coffeImage = [UIImage imageWithData:taskData];
            [_dataDelegate updateViewWithImage];
        }
        
    }];
    
    [imageDownloadTask setTaskDescription:@"image"];
    [imageDownloadTask resume];
}

/**
 * communicates with percolate api and updates the data delegate when data is retrieved
 */
-(void)downloadCoffeeData {

    NSURL *apiURL = [NSURL URLWithString:@"https://coffeeapi.percolate.com/api/coffee/?api_key=WuVbkuUsCXHPx3hsQzus4SE"];
    
    NSURLSessionDownloadTask *dataDownloadTask = [_percolateSession downloadTaskWithURL:apiURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSData *taskData = [NSData dataWithContentsOfURL:location];
            NSError *perror = nil;
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:taskData options:NSJSONReadingMutableContainers error:&perror];
            if (perror == nil) {
                NSLog(@"Response %@", responseArray);
                //_percolateDataArray = [[NSMutableArray alloc] initWithCapacity:responseArray.count];
                
                for (NSDictionary *coffee in responseArray) {
                    PercolateCoffee *percolateCoffee = [[PercolateCoffee alloc] init];
                    percolateCoffee.coffeeDesc = [coffee valueForKey:@"desc"];
                    percolateCoffee.coffeeImageURL = [coffee valueForKey:@"image_url"];
                    percolateCoffee.coffeeName = [coffee valueForKey:@"name"];
                    percolateCoffee.coffeeId = [coffee valueForKey:@"id"];
                    
                    [_dataSource addPercolateCoffee:percolateCoffee];
                }
            }
            
            [_dataDelegate updateViewWithData];

        }
        
    }];

    [dataDownloadTask setTaskDescription:@"data"];
    [dataDownloadTask resume];
}

@end
