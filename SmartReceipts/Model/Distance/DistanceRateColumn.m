//
//  DistanceRateColumn.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 05/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DistanceRateColumn.h"
#import "Distance.h"
#import "WBPrice.h"

@implementation DistanceRateColumn

- (NSString *)valueFromDistance:(Distance *)distance forCSV:(BOOL)forCSV {
    WBPrice *price = distance.rate;
    return (forCSV ? price.amountAsString : price.currencyFormattedPrice);
}

@end
