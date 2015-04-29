//
//  ReportCSVTable.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReportCSVTable.h"
#import "Column.h"

static NSString* const QUOTE = @"\"";
static NSString* const ESCAPED_QUOTE = @"\"\"";

static NSString *escapedCSV(NSString* csv) {
    if (!csv) {
        return @"";
    }


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

@interface ReportCSVTable ()

@property (nonatomic, assign) NSMutableString *content;

@end

@implementation ReportCSVTable

- (instancetype)initWithContent:(NSMutableString *)content columns:(NSArray *)columns {
    self = [super initWithColumns:columns];
    if (self) {
        _content = content;
    }

    return self;
}

- (void)appendTableWithRows:(NSArray *)rows {
    if (self.includeHeaders) {
        [self appendTableHeader];
    }

    [self appendRows:rows];
}

- (void)appendRows:(NSArray *)rows {
    for (id row in rows) {
        @autoreleasepool {
            NSMutableArray *array = [NSMutableArray array];
            for (Column *column in self.columns) {
                NSString *val = [column valueFromRow:row forCSV:YES];
                [array addObject:escapedCSV(val)];
            }

            [self.content appendString:[array componentsJoinedByString:@","]];
            [self.content appendString:@"\n"];
        }
    }
}

- (void)appendTableHeader {
    NSMutableArray *array = [NSMutableArray array];
    for (Column *column in self.columns) {
        [array addObject:escapedCSV([column name])];
    }
    [self.content appendString:[array componentsJoinedByString:@","]];
    [self.content appendString:@"\n"];
}

@end
