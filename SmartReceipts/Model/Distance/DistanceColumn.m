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
        [[DistanceLocationColumn alloc] initWithIndex:0 name:NSLocalizedString(@"distance_location_field", nil)],
        [[DistancePriceColumn alloc] initWithIndex:0 name:NSLocalizedString(@"RECEIPTMENU_FIELD_PRICE", nil)],
        [[DistanceDistanceColumn alloc] initWithIndex:0 name:NSLocalizedString(@"pref_distance_header", nil)],
        [[DistanceCurrencyColumn alloc] initWithIndex:0 name:NSLocalizedString(@"RECEIPTMENU_FIELD_CURRENCY", nil)],
        [[DistanceRateColumn alloc] initWithIndex:0 name:NSLocalizedString(@"distance_rate_field", nil)],
        [[DistanceDateColumn alloc] initWithIndex:0 name:NSLocalizedString(@"RECEIPTMENU_FIELD_DATE", nil)],
        [[DistanceCommentColumn alloc] initWithIndex:0 name:NSLocalizedString(@"RECEIPTMENU_FIELD_COMMENT", nil)],
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
