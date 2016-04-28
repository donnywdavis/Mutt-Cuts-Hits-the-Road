//
//  ViewController.m
//  MuttCutsHitsTheRoad
//
//  Created by Donny Davis on 4/28/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

#import "ViewController.h"
#import "Location.h"
#import <MapKit/MapKit.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up the frame constraints for our view
    CGRect theFrame = self.view.frame;
    theFrame.origin.x = 0;
    theFrame.origin.y = 64;
    theFrame.size.height -= 64;
    theFrame.size.width -= 0;
    
    // Let's get authorization to use the users location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
//    [self.locationManager startUpdatingLocation];
    
    // Set up the map view
    self.mapView = [[MKMapView alloc] initWithFrame:theFrame];
    
    self.mapView.showsUserLocation = YES;
    
    // Add the map view to our main view
    [self.view addSubview:self.mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
