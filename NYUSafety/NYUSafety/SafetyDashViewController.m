//
//  SafetyDashViewController.m
//  NYUSafety
//
//  Created by Michael Gerstenfeld on 4/11/15.
//  Copyright (c) 2015 nyu safety. All rights reserved.
//

#import "SafetyDashViewController.h"


@interface SafetyDashViewController()

@property (nonatomic, strong) NSDictionary *dashData;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKUserLocation *userLocation;
@property (nonatomic, strong) UIAlertView *alertView;

-(void) initializeLocationWithMap;
-(void) loadOthersLocation;
-(void) updateAllUserLocation;

@end

@implementation SafetyDashViewController

@synthesize userId = _userId;
@synthesize userMapView = _userMapView;

@synthesize dashData = _dashData;
@synthesize locationManager = _locationManager;
@synthesize userLocation = _userLocation;
@synthesize alertView = _alertView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self initializeLocationWithMap];
    //[self loadOthersLocation];
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadOthersLocation];
    [self showUserLocation];
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

#pragma mark - SafetyAPIDataDelegate

-(void) updateDelegate {
    NSLog(@"SafetyDashViewController :: updateDelegate :: start");
    
    // something went wrong
    if (_dashData == nil || [[_dashData valueForKey:@"code"] isEqualToString:@"0"]) {
        
        // this is just for debug purpose
        /*_alertView = [[UIAlertView alloc] initWithTitle:@"Sign up Error" message:@"Can not load other user's location"
                                               delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        _alertView.frame = CGRectMake(0, 0, 120.0, 120.0);
        _alertView.center = self.view.center;
        [self.view addSubview:_alertView];
        [_alertView show];
        
        // call the segue
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self showUserLocation];
        });*/
        [self showUserLocation];
        
    } else {
        // call the segue
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self updateAllUserLocation];
        });
    }
}


#pragma mark - SafetyAPIDataSource

- (NSString *)getAPIURL {
    // hacksafety.elasticbeanstalk.com/public/index.php/updatelocation/{userid}/{latitude}/{longitude}/{activity}/{type}
    if (_userLocation == nil) {
        return nil;
    }
    return [NSString stringWithFormat:@"http://hacksafety.elasticbeanstalk.com/public/index.php/updatelocation/%@/%f/%f/still/uh"
            , _userId, _userLocation.coordinate.latitude, _userLocation.coordinate.longitude];
}

-(void)updateData:(NSDictionary *)dataDictionary {
    _dashData = dataDictionary;
    
}

#pragma mark - all about location and maps

-(void)initializeLocationWithMap {
    _userMapView.delegate = self;

    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [_locationManager requestAlwaysAuthorization];
    [_locationManager requestWhenInUseAuthorization];
    
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {

        _locationManager.pausesLocationUpdatesAutomatically = NO;
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        [_locationManager startUpdatingLocation];
        [_locationManager startMonitoringSignificantLocationChanges];
        
        [self showUserLocation];

    }
}

-(void)loadOthersLocation {
    if (_userLocation == nil) {
        NSLog(@"SafetyDashViewController :: loadOthersLocation :: no user location tracked");
        return;
    }
    
    SafetyAPIDataHandler *locationDataHandler = [[SafetyAPIDataHandler alloc] init];
    locationDataHandler.delegate = self;
    locationDataHandler.dataSource = self;
    
    [locationDataHandler connectAPIForData];
    
}


-(void)updateAllUserLocation {
    NSDictionary *tempDict = (NSDictionary *)[_dashData objectForKey:@"data"];
    NSArray *allUserData = (NSArray *)[tempDict objectForKey:@"helpers"];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.0, 0.0);
    
    for (NSDictionary *locMap in allUserData) {
        NSNumber *latitude = (NSNumber *)[locMap objectForKey:@"latitude"];
        NSNumber *longitude = (NSNumber *)[locMap objectForKey:@"longitude"];
        
        CLLocationCoordinate2D location =
            CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]) ;
        
        MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
        [_userMapView setRegion:region animated:NO];
        
    }
    
    [self showUserLocation];

 }

-(void) showUserLocation {
    [_userMapView setUserInteractionEnabled:YES];
    [_userMapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    
    _userMapView.showsUserLocation = YES;
    _userLocation = _userMapView.userLocation;
}


#pragma mark - MKMapViewDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"SafetyDashViewController :: didUpdateLocations:: latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
        _userLocation = _userMapView.userLocation;
        [self loadOthersLocation];
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation {

    
    MKAnnotationView *annotationView = [aMapView dequeueReusableAnnotationViewWithIdentifier:@"spot"];
    if(!annotationView)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"spot"];
    }
    
    // Setup annotation view
    ((MKPinAnnotationView *)annotationView).pinColor = MKPinAnnotationColorPurple;
    
    return annotationView;
}

@end
