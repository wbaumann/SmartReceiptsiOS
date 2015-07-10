//
//  ReportTable.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 10/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "PDFReportTable.h"
#import "TableHeaderRow.h"

@interface PDFReportTable ()

@property (nonatomic, strong) IBOutlet TableHeaderRow *headerRowPrototype;
@property (nonatomic, strong) IBOutlet TableContentRow *rowOnePrototype;
@property (nonatomic, strong) IBOutlet TableContentRow *rowTwoPrototype;
@property (nonatomic, strong) NSMutableArray *rows;

@end

@implementation PDFReportTable

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setBackgroundColor:[UIColor clearColor]];

    [self.headerRowPrototype removeFromSuperview];
    [self.rowOnePrototype removeFromSuperview];
    [self.rowTwoPrototype removeFromSuperview];

    self.rows = [NSMutableArray array];
}

- (void)appendValues:(NSArray *)values {
    [self.rows addObject:values];
}

- (void)buildTable {
    NSMutableArray *columnsWidth = [NSMutableArray arrayWithCapacity:self.columns.count];
    for (NSInteger column = 0; column < self.columns.count; column++) {
        [columnsWidth addObject:@([self maxWidthOfColumn:column])];
    }

    CGFloat yOffset = [self appendRow:self.columns columnWidths:columnsWidth usingPrototype:self.headerRowPrototype yOffset:0];
    for (NSInteger row = 0; row < self.rows.count; row++) {
        TableContentRow *prototype;
        if (row % 2 == 0) {
            prototype = self.rowOnePrototype;
        } else {
            prototype = self.rowTwoPrototype;
        }
        yOffset = [self appendRow:self.rows[row] columnWidths:columnsWidth usingPrototype:prototype yOffset:yOffset];
    }
}

- (CGFloat)appendRow:(NSArray *)array columnWidths:(NSArray *)widths usingPrototype:(TableContentRow *)prototype yOffset:(CGFloat)yOffset {
    CGFloat height = [self maxHeightForRow:array widths:widths prototype:prototype];
    CGFloat xOffset = 0;
    for (NSInteger column = 0; column < array.count; column++) {
        NSString *value = array[column];
        TableContentRow *cell = (TableContentRow *) [self duplicate:prototype];
        [cell setValue:value];

        CGFloat width = [widths[column] floatValue];

        CGRect frame = cell.frame;
        frame.origin.x = xOffset;
        frame.origin.y = yOffset;
        frame.size.width = width;
        frame.size.height = height;
        [cell setFrame:frame];
        [self addSubview:cell];

        xOffset += width;
    }

    return yOffset + height;
}

- (CGFloat)maxHeightForRow:(NSArray *)array widths:(NSArray *)widths prototype:(TableContentRow *)prototype {
    CGFloat max = 0;

    for (NSInteger column = 0; column < array.count; column++) {
        NSString *value = array[column];
        CGFloat width = [widths[column] floatValue];
        max = MAX(max, [prototype heightForValue:value usingWidth:width]);
    }

    return max;
}

- (UIView *)duplicate:(UIView *)view {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (CGFloat)maxWidthOfColumn:(NSInteger)column {
    CGFloat maxWidth = 0;
    NSString *title = self.columns[column];
    maxWidth = MAX(maxWidth, [self.headerRowPrototype widthForValue:title]);
    for (NSArray *row in self.rows) {
        NSString *value = row[column];
        maxWidth = MAX(maxWidth, [self.rowOnePrototype widthForValue:value]);
    }

    return maxWidth;
}

@end
