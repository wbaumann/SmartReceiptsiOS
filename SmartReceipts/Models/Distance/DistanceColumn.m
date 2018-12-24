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
#import <SmartReceipts-Swift.h>

@implementation DistanceColumn

+ (NSArray *)allColumns {
    return @[
        [[DistanceLocationColumn alloc] initWithType:0 name:[WBPreferences localizedWithKey:@"distance_location_field"]],
        [[DistancePriceColumn alloc] initWithType:1 name:[WBPreferences localizedWithKey:@"distance_price_field"]],
        [[DistanceDistanceColumn alloc] initWithType:2 name:[WBPreferences localizedWithKey:@"distance_distance_field"]],
        [[DistanceCurrencyColumn alloc] initWithType:3 name:[WBPreferences localizedWithKey:@"dialog_currency_field"]],
        [[DistanceRateColumn alloc] initWithType:4 name:[WBPreferences localizedWithKey:@"distance_rate_field"]],
        [[DistanceDateColumn alloc] initWithType:5 name:[WBPreferences localizedWithKey:@"distance_date_field"]],
        [[DistanceCommentColumn alloc] initWithType:6 name:[WBPreferences localizedWithKey:@"distance_comment_field"]],
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
