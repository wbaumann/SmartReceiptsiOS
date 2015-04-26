//
//  ReportPDFTable.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReportPDFTable.h"
#import "WBPdfDrawer.h"
#import "Column.h"

static inline NSString *safeString(NSString *str) {
    return str ? str : @"";
}

@interface ReportPDFTable ()

@property (nonatomic, strong) WBPdfDrawer *pdfDrawer;

@end

@implementation ReportPDFTable

- (instancetype)initWithPDFDrawer:(WBPdfDrawer *)drawer columns:(NSArray *)columns {
    self = [super initWithColumns:columns];
    if (self) {
        _pdfDrawer = drawer;
    }
    return self;
}

- (void)appendTableWithRows:(NSArray *)rows {
    if (self.includeHeaders) {
        NSMutableArray *array = [NSMutableArray array];
        for (Column *column in self.columns) {
            [array addObject:safeString([column name])];
        }
        [self.pdfDrawer drawRowBorderedTexts:array];
    }

    for (id row in rows) {
        @autoreleasepool {
            NSMutableArray *array = [NSMutableArray array];
            for (Column *column in self.columns) {
                NSString *val = [column valueFromRow:row forCSV:NO];
                [array addObject:safeString(val)];
            }

            [self.pdfDrawer drawRowBorderedTexts:array];
        }
    }
}

@end
