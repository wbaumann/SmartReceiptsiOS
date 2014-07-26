//
//  WBColumnsResolver.m
//  SmartReceipts
//
//  Created on 03/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBColumnsResolver.h"

#import "WBCategory.h"
#import "WBColumn.h"
#import "WBTrip.h"
#import "WBReceipt.h"

#import "WBCurrency.h"

#import "WBDateFormatter.h"
#import "WBPreferences.h"

@implementation WBColumnsResolver
{
    NSDictionary *_categoriesMap;
    WBDateFormatter *_dateFormatter;
}

- (id)initWithCategories:(NSArray*) categories
{
    self = [super init];
    if (self) {
        _categoriesMap = [WBCategory namesToCodeMapFromCategories:categories];
        _dateFormatter = [[WBDateFormatter alloc] init];
    }
    return self;
}

- (NSString*)resolveToString:(WBColumn*) column forTrip:(WBTrip*) trip forReceipt:(WBReceipt*) receipt withReceiptIndex:(int) idxReceipt isCsv:(BOOL) isCsv {
    NSString* columnName = [column name];
    
#define opt(optName) ([columnName isEqualToString:(optName)])
    
    if (opt(WBColumnNameBlank)) {
        return @"";
    } else if (opt(WBColumnNameCategoryCode)) {
        return [_categoriesMap objectForKey:[receipt category]];
    } else if (opt(WBColumnNameCategoryName)) {
        return [receipt category];
    } else if (opt(WBColumnNameComment)) {
        return [receipt comment];
    } else if (opt(WBColumnNameCurrency)) {
        return [[receipt currency] code];
    } else if (opt(WBColumnNameDate)) {
        return [_dateFormatter formattedDate:[receipt dateFromDateMs] inTimeZone:[receipt timeZone]];
    } else if (opt(WBColumnNameName)) {
        return [receipt name];
    } else if (opt(WBColumnNamePrice)) {
        if (isCsv) {
            return [NSString stringWithFormat:@"%.2f",[[receipt price] doubleValue]];
        }
        return [receipt priceWithCurrencyFormatted];
    } else if (opt(WBColumnNameTax)) {
        return [receipt taxWithCurrencyFormatted];
    } else if (opt(WBColumnNameReportName)) {
        return [trip name];
    } else if (opt(WBColumnNameReportStartDate)) {
        return [_dateFormatter formattedDate:[trip startDate] inTimeZone:[trip startTimeZone]];
    } else if (opt(WBColumnNameReportEndDate)) {
        return [_dateFormatter formattedDate:[trip endDate] inTimeZone:[trip endTimeZone]];
    } else if (opt(WBColumnNameUserId)) {
        return [WBPreferences userID];
    } else if (opt(WBColumnNameImageFileName)) {
#warning FIXME: on Android (receipt.hasFile()) ? "" : receipt.getFileName() looks like bug
        return [receipt hasFileForTrip:trip] ? [receipt imageFileName] : @"";
    } else if (opt(WBColumnNameImagePath)) {
        return [receipt hasFileForTrip:trip] ? [receipt imageFilePathForTrip:trip] : @"";
    } else if (opt(WBColumnNamePictured)) {
        if ([receipt hasImageForTrip:trip]) {
            return NSLocalizedString(@"Yes", nil);
        } else if ([receipt hasPDFForTrip:trip]) {
            return NSLocalizedString(@"Yes - As PDF", nil);
        } else {
            return NSLocalizedString(@"No", nil);
        }
    } else if (opt(WBColumnNameIndex)) {
        return [NSString stringWithFormat:@"%d", idxReceipt];
    } else if (opt(WBColumnNameExpensable)) {
        return [receipt isExpensable] ? NSLocalizedString(@"Yes", nil) : NSLocalizedString(@"No", nil);
    } else if (opt(WBColumnNameExtraEdittext1)) {
        return [receipt extraEditText1];
    } else if (opt(WBColumnNameExtraEdittext2)) {
        return [receipt extraEditText2];
    } else if (opt(WBColumnNameExtraEdittext3)) {
        return [receipt extraEditText3];
    }
  
#undef opt
    return columnName;
}

@end
