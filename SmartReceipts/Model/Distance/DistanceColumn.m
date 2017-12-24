//
//  DistanceColumn.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 05/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DistanceColumn.h"
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
        [[DistanceLocationColumn alloc] initWithIndex:0 name:NSLocalizedString(@"distance.column.location", nil)],
        [[DistancePriceColumn alloc] initWithIndex:0 name:NSLocalizedString(@"distance.column.price", nil)],
        [[DistanceDistanceColumn alloc] initWithIndex:0 name:NSLocalizedString(@"distance.column.distance", nil)],
        [[DistanceCurrencyColumn alloc] initWithIndex:0 name:NSLocalizedString(@"distance.column.currency", nil)],
        [[DistanceRateColumn alloc] initWithIndex:0 name:NSLocalizedString(@"distance.column.rate", nil)],
        [[DistanceDateColumn alloc] initWithIndex:0 name:NSLocalizedString(@"distance.column.date", nil)],
        [[DistanceCommentColumn alloc] initWithIndex:0 name:NSLocalizedString(@"distance.column.comment", nil)],
    ];
}

- (NSString *)valueFromRow:(id)row forCSV:(BOOL)forCSV {
    return [self valueFromDistance:row forCSV:forCSV];
}

- (NSString *)valueFromDistance:(Distance *)distance forCSV:(BOOL)forCSV {
    ABSTRACT_METHOD;
    return nil;
}

- (NSString *)valueForFooter:(NSArray *)rows forCSV:(BOOL)forCSV {
    return @"";
}

@end
