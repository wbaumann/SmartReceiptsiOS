//
//  EditDistanceViewController.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputCellsViewController.h"

@class WBTrip;
@class Distance;

@interface EditDistanceViewController : InputCellsViewController

@property (nonatomic, strong) WBTrip *trip;
@property (nonatomic, strong) Distance *distance;

@end
