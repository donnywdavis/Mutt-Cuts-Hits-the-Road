//
//  ValidateForm.m
//  MuttCutsHitsTheRoad
//
//  Created by Donny Davis on 4/29/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

#import "ValidateForm.h"

@implementation ValidateForm

- (BOOL)isAddressValid:(NSString *)address {
    if ([address isEqualToString:@""]) {
        return NO;
    }
    if ([address componentsSeparatedByString:@", "].count < 2) {
        return NO;
    }
    return YES;
}

@end
