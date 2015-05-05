//
//  DistanceColumn.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 05/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DistanceColumn.h"
#import "Distance.h"
#import "Constants.h"
#import "DistanceLocationColumn.h"
#import "DistancePriceColumn.h"
#import "DistanceDistanceColumn.h"
#import "DistanceCurrencyColumn.h"
#import "DistanceRateColumn.h"
#import "DistanceDateColumn.h"
#import "DistanceCommentColumn.h"

@implementation DistanceColumn

+ (NSArray *)allColumns {
    return @[
        [[DistanceLocationColumn alloc] initWithIndex:0 name:NSLocalizedString(@"Location", nil)],
        [[DistancePriceColumn alloc] initWithIndex:0 name:NSLocalizedString(@"Price", nil)],
        [[DistanceDistanceColumn alloc] initWithIndex:0 name:NSLocalizedString(@"Distance", nil)],
        [[DistanceCurrencyColumn alloc] initWithIndex:0 name:NSLocalizedString(@"Currency", nil)],
        [[DistanceRateColumn alloc] initWithIndex:0 name:NSLocalizedString(@"Rate", nil)],
        [[DistanceDateColumn alloc] initWithIndex:0 name:NSLocalizedString(@"Date", nil)],
        [[DistanceCommentColumn alloc] initWithIndex:0 name:NSLocalizedString(@"Comment", nil)],
    ];
}

- (NSString *)valueFromRow:(id)row forCSV:(BOOL)forCSV {
    return [self valueFromDistance:row forCSV:forCSV];
}

- (NSString *)valueFromDistance:(Distance *)distance forCSV:(BOOL)forCSV {
    ABSTRACT_METHOD;
    return nil;
}

@end
