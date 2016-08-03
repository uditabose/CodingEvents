//
//  PercolateCoffeListViewController.m
//  iPercolateCoffee
//
//  Created by Udita Bose on 3/23/15.
//
//

#import "PercolateCoffeListViewController.h"
#import "PercolateCoffee.h"
#import "PercolateDataHandler.h"
#import "PercolateCoffeeSimpleCell.h"
#import "PercolateCoffeeImageCell.h"
#import "PercolateCoffeeHeaderView.h"

@interface PercolateCoffeListViewController ()


@property (strong, nonatomic) NSArray *coffeeDataArray;
@property (strong, nonatomic) PercolateDataHandler *coffeeDataHandler;

-(void) initiateCoffeTableView;

@end

@implementation PercolateCoffeListViewController

@synthesize tableView = _tableView;
@synthesize coffeeDataArray = _coffeeDataArray;
@synthesize coffeeDataHandler = _coffeeDataHandler;

-(void)awakeFromNib {
    
    // sets the properties of subviews and starts data download
    [self initiateCoffeTableView];
}
- (void)viewDidLoad {
    
    // this hides the top status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 * hides the status bar
 */
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - PercolateDataHandlerProtocol

/**
 * updates the table view after each image is downloaded
 */
-(void)updateViewWithImage {
    // update view with image data
    dispatch_sync(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
    
}

/**
 * updates table view after the api json data is downloaded but not the images yet
 */
-(void)updateViewWithData {
    // for all data
    dispatch_sync(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}

#pragma mark - PercolateDataHandlerDataSource

/**
 * returns a coffee object from backing datasource
 */
-(PercolateCoffee *)getPercolateCoffee:(NSIndexPath *)imageIndex {
    NSInteger currentRow = imageIndex.row;
    if (_coffeeDataArray != nil && currentRow < _coffeeDataArray.count) {
        PercolateCoffee *rowData = [_coffeeDataArray objectAtIndex:currentRow];
        return rowData;
    }
    return nil;
}

/**
 * adds coffee data to backing datasource
 */
-(void)addPercolateCoffee:(PercolateCoffee *)percolateCoffee {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    if (_coffeeDataArray != nil) {
        [tempArray addObjectsFromArray:_coffeeDataArray];
        
    }
    [tempArray addObject:percolateCoffee];
    _coffeeDataArray = [NSArray arrayWithArray:tempArray];
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_coffeeDataArray != nil) {
        return _coffeeDataArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger currentRow = indexPath.row;
    UITableViewCell *rowCell = nil;
    
    if (_coffeeDataArray != nil && currentRow < _coffeeDataArray.count) {
        PercolateCoffee *rowData = [_coffeeDataArray objectAtIndex:currentRow];
        
        
        if (rowData.coffeeImageURL == nil || [rowData.coffeeImageURL isEqualToString:@""]) {
            // this cell will not have an image
            rowCell = [tableView  dequeueReusableCellWithIdentifier:@"simpleCell"];
            PercolateCoffeeSimpleCell *simpleCell = (PercolateCoffeeSimpleCell *)rowCell;
            [simpleCell prepareCellForDisplay:rowData];
        } else {
            // this cell will have an image
            rowCell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            PercolateCoffeeImageCell *imageCell = (PercolateCoffeeImageCell *)rowCell;
            
            if (rowData.coffeImage == nil) {
                [_coffeeDataHandler downloadImage:indexPath];
            }
            
            // uodate cell data
            [imageCell prepareCellForDisplay:rowData];
            
        }
        
        [rowCell setNeedsUpdateConstraints];
        [rowCell updateConstraintsIfNeeded];
        
    } else {
        rowCell = [tableView  dequeueReusableCellWithIdentifier:nil];
    }
    
    return rowCell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger currentRow = indexPath.row;
    if (_coffeeDataArray != nil && currentRow < _coffeeDataArray.count) {
        PercolateCoffee *rowData = [_coffeeDataArray objectAtIndex:currentRow];
        
        if (rowData.coffeeImageURL == nil || [rowData.coffeeImageURL isEqualToString:@""]) {
            return 113;
            
        } else {
            return 255;
        }
        
    }
    
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"PercolateCoffeeHeaderView" owner:self options:nil];
    PercolateCoffeeHeaderView *headerView = [ nibViews objectAtIndex: 0];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

/**
 * initiates the sub view status and stars data download
 */
-(void) initiateCoffeTableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
    }
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    UINib *imageCellNib = [UINib nibWithNibName:@"PercolateCoffeeImageCell" bundle:mainBundle];
    UINib *simpleCellNib = [UINib nibWithNibName:@"PercolateCoffeeSimpleCell" bundle:mainBundle];
    
    [_tableView registerNib:imageCellNib forCellReuseIdentifier:@"imageCell"];
    [_tableView registerNib:simpleCellNib forCellReuseIdentifier:@"simpleCell"];
    
    _tableView.tableFooterView =[[UIView alloc] initWithFrame:CGRectZero];
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _coffeeDataHandler = [[PercolateDataHandler alloc] init];
    _coffeeDataHandler.dataDelegate = self;
    _coffeeDataHandler.dataSource = self;
    [_coffeeDataHandler downloadCoffeeData];
}

-(void)dealloc {
    _tableView = nil;
    _coffeeDataHandler = nil;
    _coffeeDataArray = nil;

}

@end
