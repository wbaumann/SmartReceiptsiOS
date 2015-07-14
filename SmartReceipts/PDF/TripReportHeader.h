//
//  TripReportHeader.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 09/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripReportHeader : UIView

- (void)setTripName:(NSString *)name;
- (void)appendRow:(NSString *)row;

@end
