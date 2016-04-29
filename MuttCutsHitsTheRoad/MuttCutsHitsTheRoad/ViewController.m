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
- (void)dismissMe;

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
    [self convertStringToLocation:@"Durham, NC"];

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
    NSLog(@"Count: %lu", (unsigned long)self.selectedLocations.count);
    if (self.selectedLocations.count >= 2) {
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:self.selectedLocations[0].coordinate.latitude longitude:self.selectedLocations[0].coordinate.longitude];
        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:self.selectedLocations[1].coordinate.latitude longitude:self.selectedLocations[1].coordinate.longitude];
        float latitude = (location1.coordinate.latitude + location2.coordinate.latitude) / 2;
        float longitude = (location1.coordinate.longitude + location2.coordinate.longitude) / 2;
        CLLocationDistance distance = [location1 distanceFromLocation:location2];
        CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerLocation.coordinate, distance, distance);
        NSLog(@"latitude: %f", latitude);
        NSLog(@"longitude: %f", longitude);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    }
}

#pragma mark - Bar Button Actions

- (void)dismissMe {
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
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissMe)];
    navController.navigationBar.topItem.rightBarButtonItem = doneButton;
    return navController;
}

#pragma mark - PopoverLocationSelectionDelegate

//- (void)setSelectedLocation:(NSArray *)locations {
//    if (locations) {
//        for (Location *address in locations) {
//            [self.selectedLocations addObject:address];
//        }
//        NSLog(@"Location: %@", [self.selectedLocations description]);
//    } else {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Cannot plot points. Invalid location(s) selected." preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:okButton];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//}

#pragma mark - CLLocationManagerDelegate

@end
