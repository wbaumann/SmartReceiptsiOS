//
//  PendingHUDView.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 23/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRProgressOverlayView.h"

@interface PendingHUDView : MRProgressOverlayView

+ (PendingHUDView *)showHUDOnView:(UIView *)view;
- (void)hide;

@end
