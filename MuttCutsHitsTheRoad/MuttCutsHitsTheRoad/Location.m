//
//  Location.m
//  MuttCutsHitsTheRoad
//
//  Created by Donny Davis on 4/28/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype)initWithCoord:(CLLocationCoordinate2D)coord title:(NSString *)title subtitle:(NSString *)subtitle {
    self = [super init];
    if (self) {
        _coordinate = coord;
        _title = title;
        _subtitle = subtitle;
    }
    
    return self;
}

@end
