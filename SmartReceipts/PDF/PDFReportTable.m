//
//  ReportTable.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 10/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "PDFReportTable.h"
#import "TableHeaderRow.h"

#define MINIMUM_COLUMN_WIDTH 24.0f

@interface PDFReportTable ()

@property (nonatomic, strong) IBOutlet TableHeaderRow *headerRowPrototype;
@property (nonatomic, strong) IBOutlet TableContentRow *rowOnePrototype;
@property (nonatomic, strong) IBOutlet TableContentRow *rowTwoPrototype;
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, assign) NSUInteger rowsAdded;
@property (nonatomic, assign) NSUInteger rowToStart;
@property (nonatomic, assign) BOOL tableHeaderAdded;
@property (nonatomic, assign, readwrite) BOOL hasTooManyColumnsToFitWidth;

@end

@implementation PDFReportTable

#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setBackgroundColor:[UIColor clearColor]];

    [self.headerRowPrototype removeFromSuperview];
    [self.rowOnePrototype removeFromSuperview];
    [self.rowTwoPrototype removeFromSuperview];

    [self setClipsToBounds:YES];

    self.rows = [NSMutableArray array];
}

#pragma mark - Public

- (void)appendValues:(NSArray *)values {
    [self.rows addObject:values];
}

- (BOOL)buildTable:(CGFloat)availableSpace {
    NSMutableArray *columnsWidth = [NSMutableArray arrayWithCapacity:self.columns.count];
    NSMutableArray *titleWidth = [NSMutableArray arrayWithCapacity:self.columns.count];
    
    for (NSUInteger column = 0; column < self.columns.count; column++) {
        [columnsWidth addObject:@([self maxWidthOfColumn:column])];
        [titleWidth addObject:@(ceilf([self.headerRowPrototype widthForValue:self.columns[column]]))];
    }

    columnsWidth = [self divideRemainingWidth:columnsWidth titleWidth:titleWidth];
    
    CGFloat yOffset = 0;
    // Don't add header on view where already added
    // Happens when we decide that not enough rows in page and push all to next page.
    // In that case original table is reused, just additional rows added
    if (!self.tableHeaderAdded) {
        yOffset = [self appendRow:self.columns columnWidths:columnsWidth usingPrototype:self.headerRowPrototype yOffset:0];
        [self setTableHeaderAdded:YES];
        [self setFrameHeightTo:yOffset];
    } else {
        yOffset = CGRectGetHeight(self.frame);
    }

    for (NSUInteger row = self.rowToStart; row < self.rows.count; row++) {
        TableContentRow *prototype;
        if (row % 2 == 0) {
            prototype = self.rowOnePrototype;
        } else {
            prototype = self.rowTwoPrototype;
        }
        
        CGFloat height = [self maxHeightForRow:self.rows[row] widths:columnsWidth prototype:prototype];
        if (yOffset + height > availableSpace) {
            [self setRowsAdded:row];
            return NO;
        }

        yOffset = [self appendRow:self.rows[row] columnWidths:columnsWidth usingPrototype:prototype yOffset:yOffset];
        [self setFrameHeightTo:yOffset];
    }
    
    return YES;
}

#pragma mark - Private methods

- (void)setFrameHeightTo:(CGFloat)height {
    CGRect myFrame = self.frame;
    myFrame.size.height = height;
    [self setFrame:myFrame];
}

- (NSMutableArray *)divideRemainingWidth:(NSMutableArray *)columns titleWidth:(NSArray *)titleWidth {
    NSNumber *width = [columns valueForKeyPath:@"@sum.self"];
    CGFloat columnsWidth = [width floatValue];
    if (columnsWidth <= CGRectGetWidth(self.frame)) {
        columns = [self divideRemainingEqually:columns columnsWidth:columnsWidth];
    } else {
        columns = [self fitColumnsWidth:columns titleWidth:titleWidth];
    }

    return columns;
}

- (NSMutableArray *)fitColumnsWidth:(NSMutableArray *)columns titleWidth:(NSArray *)titleWidths {
    NSMutableIndexSet *indexesToModify = [NSMutableIndexSet indexSet];
    NSMutableIndexSet *indexesNotToModify = [NSMutableIndexSet indexSet];
    for (NSUInteger index = 0; index < columns.count; index++) {
        if ([self canSqueezeColumn:self.columns[index]]) {
            [indexesToModify addIndex:index];
        } else {
            [indexesNotToModify addIndex:index];
        }
    }

    NSNumber *totalWidthOfNotModified = [[columns objectsAtIndexes:indexesNotToModify] valueForKeyPath:@"@sum.self"];
    NSNumber *totalWidthOfModified = [[columns objectsAtIndexes:indexesToModify] valueForKeyPath:@"@sum.self"];
    NSNumber *modifiedTitleWidths = [[titleWidths objectsAtIndexes:indexesToModify] valueForKeyPath:@"@sum.self"];
    CGFloat spaceToDivide = CGRectGetWidth(self.frame) - totalWidthOfNotModified.floatValue - modifiedTitleWidths.floatValue;

    NSMutableArray *modifiedColumns = [NSMutableArray arrayWithCapacity:columns.count];
    for (NSUInteger index = 0; index < columns.count; index++) {
        if ([indexesNotToModify containsIndex:index]) {
            [modifiedColumns addObject:columns[index]];
            continue;
        }

        NSNumber *columnWidth = columns[index];
        CGFloat percent = columnWidth.floatValue / totalWidthOfModified.floatValue;
        NSNumber *titleWidth = titleWidths[index];
        float squeezedTitleWidth = titleWidth.floatValue + floorf(spaceToDivide * percent);
        
        // check if all the columns can be placed within the table (if there enough available width)
        if (squeezedTitleWidth < MINIMUM_COLUMN_WIDTH) {
            // user able to ignore this warning and continue rendering pages if needed
            LOGGER_WARNING(@"Too many table columns to fit this page");
            self.hasTooManyColumnsToFitWidth = YES;
        }
        
        [modifiedColumns addObject:@(squeezedTitleWidth)];
    }

    return modifiedColumns;
}

- (BOOL)canSqueezeColumn:(NSString *)title {
    return [NSLocalizedString(@"receipt.column.comment", nil) isEqualToString:title]
            || [NSLocalizedString(@"receipt.column.name", nil) isEqualToString:title]
            || [NSLocalizedString(@"receipt.column.report.comment", nil) isEqualToString:title]
            || [NSLocalizedString(@"receipt.column.blank.column", nil) isEqualToString:title];
}

- (NSMutableArray *)divideRemainingEqually:(NSMutableArray *)columns columnsWidth:(CGFloat)columnsWidth {
    CGFloat remainder = CGRectGetWidth(self.frame) - columnsWidth;
    CGFloat toAdd = ceilf(remainder / (CGFloat)columns.count);
    NSMutableArray *added = [NSMutableArray arrayWithCapacity:columns.count];
    for (NSUInteger index = 0; index < columns.count; index++) {
        NSNumber *number = columns[index];
        if (toAdd > remainder) {
            toAdd = remainder;
        }

        [added addObject:@(number.floatValue + toAdd)];
        remainder -= toAdd;
    }

    return added;
}

- (CGFloat)appendRow:(NSArray *)array columnWidths:(NSArray *)widths usingPrototype:(TableContentRow *)prototype yOffset:(CGFloat)yOffset {
    CGFloat height = [self maxHeightForRow:array widths:widths prototype:prototype];
    CGFloat xOffset = 0;
    for (NSUInteger column = 0; column < array.count; column++) {
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

    for (NSUInteger column = 0; column < array.count; column++) {
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

    return ceilf(maxWidth);
}

@end
