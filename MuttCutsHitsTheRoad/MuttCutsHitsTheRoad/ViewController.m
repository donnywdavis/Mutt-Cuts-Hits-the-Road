//
//  ViewController.m
//  MuttCutsHitsTheRoad
//
//  Created by Donny Davis on 4/28/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

#import "ViewController.h"
#import "PopoverViewController.h"
#import "Location.h"
#import <MapKit/MapKit.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray<Location *> *selectedLocations;

- (IBAction)showPopover:(id)sender;
- (IBAction)getCurrentLocation:(id)sender;
- (void)convertStringToLocation:(NSString *)addressString;
- (IBAction)dismissMe:(id)sender;

- (void)zoomMapToRegionEncapsulatingLocation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Mutts Cutts";
    
    self.selectedLocations = [[NSMutableArray alloc] init];
    
    // Add our bar button items for the navigation controller
    UIBarButtonItem *popoverButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showPopover:)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = popoverButton;
    UIBarButtonItem *currentLocationButton = [[UIBarButtonItem alloc] initWithTitle:@"Current" style:UIBarButtonItemStylePlain target:self action:@selector(getCurrentLocation:)];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = currentLocationButton;
    
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
    
    // Set up the map view
    self.mapView = [[MKMapView alloc] initWithFrame:theFrame];
    
    self.mapView.showsUserLocation = YES;
    
    // Add the map view to our main view
    [self.view addSubview:self.mapView];
    
    [self.locationManager startUpdatingLocation];
    [self convertStringToLocation:@"Raleigh, NC"];
    [self convertStringToLocation:@"Chattanooga, TN"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)convertStringToLocation:(NSString *)addressString {
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    __block Location *addressLocation = nil;
    [geoCoder geocodeAddressString:addressString completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", [error description]);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            addressLocation = [[Location alloc] initWithCoord:CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude) title:placemark.locality subtitle:@""];
            [self.mapView addAnnotation:addressLocation];
            [self.selectedLocations addObject:addressLocation];
            [self zoomMapToRegionEncapsulatingLocation];
            NSLog(@"Coordinates for %@", addressLocation.title);
            NSLog(@"Latitude: %f", placemark.location.coordinate.latitude);
            NSLog(@"Longitude: %f", placemark.location.coordinate.longitude);
        }
    }];
}

- (void)zoomMapToRegionEncapsulatingLocation {
    if (self.selectedLocations.count >= 2) {
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:self.selectedLocations[0].coordinate.latitude longitude:self.selectedLocations[0].coordinate.longitude];
        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:self.selectedLocations[1].coordinate.latitude longitude:self.selectedLocations[1].coordinate.longitude];
        float latitude = (location1.coordinate.latitude + location2.coordinate.latitude) / 2;
        float longitude = (location1.coordinate.longitude + location2.coordinate.longitude) / 2;
        CLLocationDistance distance = [location1 distanceFromLocation:location2];
        NSLog(@"Distance in miles: %f", (distance / 1000.0) * 0.62137);
        CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerLocation.coordinate, distance, distance);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
        
        
        CGRect distanceFrame = self.view.frame;
        distanceFrame.origin.x = 20;
        distanceFrame.origin.y = 84;
        distanceFrame.size.height = 50;
        distanceFrame.size.width = self.view.frame.size.width * 0.9;
        UIView *distanceView = [[UIView alloc] initWithFrame:distanceFrame];
        distanceView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.7];
        
        UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, distanceView.frame.size.width, distanceView.frame.size.height)];
        distanceLabel.text = [NSString stringWithFormat:@"Line of sight distance: %f", (distance / 1000.0) * 0.62137];
        distanceLabel.textColor = [UIColor blackColor];
        distanceLabel.textAlignment = NSTextAlignmentCenter;
        [distanceView addSubview:distanceLabel];
        
        [self.view addSubview:distanceView];
    }
}

#pragma mark - Bar Button Actions

- (IBAction)dismissMe:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showPopover:(id)sender {
    
    // grab the view controller we want to show
    PopoverViewController *controller = [[PopoverViewController alloc] init];
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationPopover;
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = sender;
    popController.delegate = self;
    popController.sourceView = sender;
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)getCurrentLocation:(id)sender {
    [self.locationManager startUpdatingLocation];
    CLLocation *currentLocation = self.mapView.userLocation.location;
    Location *current = [[Location alloc] initWithCoord:CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude) title:@"Current Location" subtitle:@""];
    [self.mapView addAnnotation:current];
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - UIPopoverPresentationControllerDelegate

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    NSLog(@"Hello from should dismiss");
    return YES;
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    NSLog(@"%@", [popoverPresentationController description]);
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationFullScreen;
}

- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller.presentedViewController];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissMe:)];
    navController.navigationBar.topItem.rightBarButtonItem = doneButton;
    return navController;
}

#pragma mark - PopoverLocationSelectionDelegate

- (void)setSelectedLocation:(NSArray *)locations {
    if (locations) {
        for (Location *address in locations) {
            [self.selectedLocations addObject:address];
        }
        NSLog(@"Location: %@", [self.selectedLocations description]);
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Cannot plot points. Invalid location(s) selected." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okButton];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - CLLocationManagerDelegate

@end
