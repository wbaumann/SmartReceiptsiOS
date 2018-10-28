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
#import "LocalizedString.h"

@implementation DistanceColumn

+ (NSArray *)allColumns {
    return @[
        [[DistanceLocationColumn alloc] initWithType:0 name:LocalizedString(@"distance_location_field", nil)],
        [[DistancePriceColumn alloc] initWithType:1 name:LocalizedString(@"distance_price_field", nil)],
        [[DistanceDistanceColumn alloc] initWithType:2 name:LocalizedString(@"distance_distance_field", nil)],
        [[DistanceCurrencyColumn alloc] initWithType:3 name:LocalizedString(@"dialog_currency_field", nil)],
        [[DistanceRateColumn alloc] initWithType:4 name:LocalizedString(@"distance_rate_field", nil)],
        [[DistanceDateColumn alloc] initWithType:5 name:LocalizedString(@"distance_date_field", nil)],
        [[DistanceCommentColumn alloc] initWithType:6 name:LocalizedString(@"distance_comment_field", nil)],
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
