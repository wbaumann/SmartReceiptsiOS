//
//  DistanceCurrencyColumn.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 05/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DistanceCurrencyColumn.h"
#import "Distance.h"
#import "Price.h"

@implementation DistanceCurrencyColumn

- (NSString *)valueFromDistance:(Distance *)distance forCSV:(BOOL)forCSV {
    return distance.rate.currency.code;
}

@end
