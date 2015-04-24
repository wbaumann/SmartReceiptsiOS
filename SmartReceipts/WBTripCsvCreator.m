//
//  WBTripCsvCreator.m
//  SmartReceipts
//
//  Created on 04/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTripCsvCreator.h"
#import "WBReceiptAndIndex.h"
#import "Column.h"
#import "ReceiptColumn.h"
#import "WBTrip.h"

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

@interface WBTripCsvCreator ()

@property (nonatomic, strong) NSArray *columns;

@end

@implementation WBTripCsvCreator

- (id)initWithColumns:(NSArray *)columns {
    self = [super init];
    if (self) {
        _columns = columns;
    }
    return self;
}

- (BOOL)createCsvFileAtPath:(NSString *)filePath receiptsAndIndexes:(NSArray *)receiptsAndIndexes trip:(WBTrip *)trip includeHeaders:(BOOL)includeHeaders {
    NSLog(@"Columns:%@", self.columns);
    NSLog(@"Receipts:%@", receiptsAndIndexes);

    NSMutableString *data = [[NSMutableString alloc] init];

    if (includeHeaders) {
        NSMutableArray *array = @[].mutableCopy;
        for (Column *column in self.columns) {
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
            for (ReceiptColumn *column in self.columns) {
                NSString *val = [column valueFromReceipt:receipt inTrip:trip receiptIndex:index forCSV:YES];
                [array addObject:escapedCSV(val)];
            }

            [data appendString:[array componentsJoinedByString:@","]];
            [data appendString:@"\n"];
        }
    }

    NSLog(@"Data:'%@'", data);
    NSError *writeError = nil;
    BOOL writeSuccess = [data writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
    if (writeError) {
        NSLog(@"CSV write error:%@", writeError);
    }

    return writeSuccess;
}

@end
