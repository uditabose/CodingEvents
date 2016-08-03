//
//  SafetyDashViewController.h
//  NYUSafety
//
//  Created by Michael Gerstenfeld on 4/11/15.
//  Copyright (c) 2015 nyu safety. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SafetyAPIDataHandler.h"

@interface SafetyDashViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, SafetyAPIDataDelegate, SafetyAPIDataSource>
@property (weak, nonatomic) IBOutlet MKMapView *userMapView;
@property (strong, nonatomic) NSString *userId;

@end
