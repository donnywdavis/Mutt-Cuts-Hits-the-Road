//
//  PopoverViewController.h
//  MuttCutsHitsTheRoad
//
//  Created by Donny Davis on 4/28/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@protocol PopoverLocationSelectionDelegate

- (void)setSelectedLocation:(NSArray *)locations;

@end

@interface PopoverViewController : UIViewController

@property (strong, nonatomic) id<UIPopoverPresentationControllerDelegate> delegate;

@end
