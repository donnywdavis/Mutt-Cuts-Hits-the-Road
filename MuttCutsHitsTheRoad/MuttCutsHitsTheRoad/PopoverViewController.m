//
//  PopoverViewController.m
//  MuttCutsHitsTheRoad
//
//  Created by Donny Davis on 4/28/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

#import "PopoverViewController.h"
#import <MapKit/MapKit.h>

@interface PopoverViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *addressOne;
@property (strong, nonatomic) UITextField *addressTwo;
@property (strong, nonatomic) NSMutableArray *locations;

- (void)validateAddresses:(NSArray *)addresses;

@end

@implementation PopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locations = [[NSMutableArray alloc] init];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
    view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    CGRect textFieldFrameOne = CGRectMake(view.bounds.origin.x + 20, view.bounds.origin.y + 20, view.bounds.size.width * 0.9, 40);
    CGRect textFieldFrameTwo = CGRectMake(view.bounds.origin.x + 20, textFieldFrameOne.origin.y * 4, view.bounds.size.width * 0.9, 40);
    
    self.addressOne = [[UITextField alloc] initWithFrame:textFieldFrameOne];
    self.addressOne.backgroundColor = [UIColor whiteColor];
    self.addressOne.borderStyle = UITextBorderStyleRoundedRect;
    self.addressOne.placeholder = @"City, St";
    self.addressOne.returnKeyType = UIReturnKeyNext;
    self.addressOne.enablesReturnKeyAutomatically = YES;
    self.addressOne.delegate = self;
    
    self.addressTwo = [[UITextField alloc] initWithFrame:textFieldFrameTwo];
    self.addressTwo.backgroundColor = [UIColor whiteColor];
    self.addressTwo.borderStyle = UITextBorderStyleRoundedRect;
    self.addressTwo.placeholder = @"City, St";
    self.addressTwo.returnKeyType = UIReturnKeyRoute;
    self.addressTwo.enablesReturnKeyAutomatically = YES;
    self.addressTwo.delegate = self;
    
    [view addSubview:self.addressOne];
    [view addSubview:self.addressTwo];
    [self.view addSubview:view];
    
    [self.addressOne becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.delegate popoverPresentationControllerDidDismissPopover:self.popoverPresentationController];
//    if (self.locations.count < 2) {
//        self.locations = nil;
//    }
//    [self.delegate setSelectedLocation:self.locations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.addressOne]) {
        [self.addressOne resignFirstResponder];
        [self.addressTwo becomeFirstResponder];
        return YES;
    } else if ([textField isEqual:self.addressTwo]) {
        [self.addressTwo resignFirstResponder];
        [self validateAddresses:@[self.addressOne.text, self.addressTwo.text]];
        return YES;
    }
    
    return NO;
}

#pragma mark - Validate Addresses

- (void)validateAddresses:(NSArray *)addresses {
    [self.locations addObject:addresses[0]];
    [self.locations addObject:addresses[1]];
//    [self.delegate setSelectedLocation:self.locations];
//    int index = 0;
//    while (index < addresses.count) {
//        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
//        [geoCoder geocodeAddressString:addresses[index] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//            Location *addressLocation = nil;
//            if (error) {
//                NSLog(@"%@", [error description]);
//            } else {
//                CLPlacemark *placemark = [placemarks lastObject];
//                addressLocation = [[Location alloc] initWithCoord:CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude) title:addresses[index] subtitle:@""];
//                [self.locations addObject:addressLocation];
//                NSLog(@"Coordinates for %@", addressLocation.title);
//                NSLog(@"Latitude: %f", placemark.location.coordinate.latitude);
//                NSLog(@"Longitude: %f", placemark.location.coordinate.longitude);
//            }
//        
//        }];
//        index += 1;
//    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
