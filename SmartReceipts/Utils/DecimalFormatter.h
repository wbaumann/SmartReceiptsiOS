//
//  DecimalFormatter.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 03/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DecimalFormatter : NSNumberFormatter

+ (NSString *)formatDouble:(double)value decimalPlaces:(NSUInteger)allowedDecimalPlaces;

@end
