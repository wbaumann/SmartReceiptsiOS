//
//  WBTripCsvCreator.m
//  SmartReceipts
//
//  Created on 04/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTripCsvCreator.h"

#import "WBColumnsResolver.h"
#import "WBDateFormatter.h"

#import "WBReceiptAndIndex.h"

#import "WBReportUtils.h"

static NSString* const QUOTE = @"\"";
static NSString* const ESCAPED_QUOTE = @"\"\"";

static NSString *escapedCSV(NSString* csv) {
    if (!csv)
        return @"";
    
#warning FIXME: on Android is csv.replace(QUOTE, ESCAPED_QUOTE); that means that result of replacement is not saved
    
    if ([csv rangeOfString:QUOTE].location != NSNotFound){
        csv = [csv stringByReplacingOccurrencesOfString:QUOTE withString:ESCAPED_QUOTE];
    }
    
    for (NSString *toquote in @[@",", @"\"", @"\n", @"\r\n"]) {
        if ([csv rangeOfString:toquote].location != NSNotFound) {
            csv = [NSString stringWithFormat:@"%@%@%@",QUOTE,csv,QUOTE];
            break;
        }
    }
    
    return csv;
}

@implementation WBTripCsvCreator
{
    WBColumnsResolver *_columnsResolver;
    NSArray *_columns;
}

- (id)initWithColumns:(NSArray*)columns columnsResolver:(WBColumnsResolver*)columnsResolver
{
    self = [super init];
    if (self) {
        _columns = columns;
        _columnsResolver = columnsResolver;
    }
    return self;
}

-(BOOL) createCsvFileAtPath:(NSString*) filePath receiptsAndIndexes:(NSArray*)receiptsAndIndexes trip:(WBTrip*) trip includeHeaders:(BOOL) includeHeaders {

    NSMutableString* data = [[NSMutableString alloc] init];
    
    if (includeHeaders) {
        NSMutableArray *array = @[].mutableCopy;
        for (WBColumn* column in _columns) {
            [array addObject:escapedCSV([column name])];
        }
        [data appendString:[array componentsJoinedByString:@","]];
        [data appendString:@"\n"];
    }
    
    for (WBReceiptAndIndex *rwi in receiptsAndIndexes) {
        @autoreleasepool {
            WBReceipt *receipt = [rwi receipt];
            int index = [rwi index];
            
            NSMutableArray *array = @[].mutableCopy;
            for (WBColumn* column in _columns) {
                NSString *val = [_columnsResolver resolveToString:column forTrip:trip forReceipt:receipt withReceiptIndex:index isCsv:YES];
                [array addObject:escapedCSV(val)];
            }
            
            [data appendString:[array componentsJoinedByString:@","]];
            [data appendString:@"\n"];
        }
    }
    
    return [data writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
