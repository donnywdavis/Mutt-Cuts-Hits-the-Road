//
//  PopoverViewController.m
//  MuttCutsHitsTheRoad
//
//  Created by Donny Davis on 4/28/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

#import "PopoverViewController.h"
#import <MapKit/MapKit.h>
#import "ValidateForm.h"

@interface PopoverViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *addressOne;
@property (strong, nonatomic) UITextField *addressTwo;
@property (strong, nonatomic) NSMutableArray *locations;

@property (strong, nonatomic) ValidateForm *validateForm;

- (void)displayErrorForTitle:(NSString *)title message:(NSString *)message;

@end

@implementation PopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.validateForm = [[ValidateForm alloc] init];
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
    self.addressOne.tag = 1;
    self.addressOne.delegate = self;
    
    self.addressTwo = [[UITextField alloc] initWithFrame:textFieldFrameTwo];
    self.addressTwo.backgroundColor = [UIColor whiteColor];
    self.addressTwo.borderStyle = UITextBorderStyleRoundedRect;
    self.addressTwo.placeholder = @"City, St";
    self.addressTwo.returnKeyType = UIReturnKeyRoute;
    self.addressTwo.enablesReturnKeyAutomatically = YES;
    self.addressTwo.tag = 2;
    self.addressTwo.delegate = self;
    
    [view addSubview:self.addressOne];
    [view addSubview:self.addressTwo];
    [self.view addSubview:view];
    
    [self.addressOne becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.addressOne]) {
        if ([self.validateForm isAddressValid:textField.text]) {
            [self.locations addObject:textField.text];
            [self.addressOne resignFirstResponder];
            [self.addressTwo becomeFirstResponder];
            return YES;
        } else {
            [self displayErrorForTitle:@"Error" message:@"Invalid city, state entered"];
        }
        
    } else if ([textField isEqual:self.addressTwo]) {
        if ([self.validateForm isAddressValid:textField.text]) {
            [self.locations addObject:textField.text];
            [self.addressTwo resignFirstResponder];
            return YES;
        } else {
            [self displayErrorForTitle:@"Error" message:@"Invalid city, state entered"];
        }
    }
    
    return NO;
}

#pragma mark - Error Handling

- (void)displayErrorForTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okButton];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
