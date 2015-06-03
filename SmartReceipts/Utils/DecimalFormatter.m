//
//  DecimalFormatter.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 03/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DecimalFormatter.h"

@implementation DecimalFormatter

+ (NSString *)formatDouble:(double)value decimalPlaces:(NSUInteger)allowedDecimalPlaces {
    DecimalFormatter *formatter = [[DecimalFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setUsesGroupingSeparator:NO];
    [formatter setMinimumFractionDigits:0];
    [formatter setMaximumFractionDigits:allowedDecimalPlaces];
    [formatter setRoundingIncrement:@0.00000000000000001F];
    return [formatter stringFromNumber:@(value)];
}

@end
