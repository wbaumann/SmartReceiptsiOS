//
//  ReceiptColumn.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumn.h"
#import "WBReceipt.h"
#import "Constants.h"
#import "WBColumn.h"
#import "ReceiptColumnBlank.h"
#import "ReceiptColumnCategoryCode.h"
#import "ReceiptColumnCategoryName.h"
#import "ReceiptColumnUserID.h"
#import "ReceiptColumnReportName.h"
#import "ReceiptColumnReportStartDate.h"
#import "WBTrip.h"
#import "ReceiptColumnReportEndDate.h"
#import "ReceiptColumnImageName.h"
#import "ReceiptColumnImagePath.h"
#import "ReceiptColumnComment.h"
#import "ReceiptColumnCurrency.h"
#import "ReceiptColumnDate.h"
#import "ReceiptColumnName.h"
#import "ReceiptColumnPrice.h"
#import "ReceiptColumnTax.h"
#import "ReceiptColumnPictured.h"
#import "ReceiptColumnExpensable.h"
#import "ReceiptColumnReceiptIndex.h"
#import "ReceiptUnknownColumn.h"

static NSDictionary *__receiptColumnNameToClassMapping;

@implementation ReceiptColumn

+ (void)initialize {
    __receiptColumnNameToClassMapping = @{
            WBColumnNameBlank : NSStringFromClass([ReceiptColumnBlank class]),
            WBColumnNameCategoryCode : NSStringFromClass([ReceiptColumnCategoryCode class]),
            WBColumnNameCategoryName : NSStringFromClass([ReceiptColumnCategoryName class]),
            WBColumnNameUserId : NSStringFromClass([ReceiptColumnUserID class]),
            WBColumnNameReportName : NSStringFromClass([ReceiptColumnReportName class]),
            WBColumnNameReportStartDate : NSStringFromClass([ReceiptColumnReportStartDate class]),
            WBColumnNameReportEndDate : NSStringFromClass([ReceiptColumnReportEndDate class]),
            WBColumnNameImageFileName : NSStringFromClass([ReceiptColumnImageName class]),
            WBColumnNameImagePath : NSStringFromClass([ReceiptColumnImagePath class]),
            WBColumnNameComment : NSStringFromClass([ReceiptColumnComment class]),
            WBColumnNameCurrency : NSStringFromClass([ReceiptColumnCurrency class]),
            WBColumnNameDate : NSStringFromClass([ReceiptColumnDate class]),
            WBColumnNameName : NSStringFromClass([ReceiptColumnName class]),
            WBColumnNamePrice : NSStringFromClass([ReceiptColumnPrice class]),
            WBColumnNameTax : NSStringFromClass([ReceiptColumnTax class]),
            WBColumnNamePictured : NSStringFromClass([ReceiptColumnPictured class]),
            WBColumnNameExpensable : NSStringFromClass([ReceiptColumnExpensable class]),
            WBColumnNameIndex : NSStringFromClass([ReceiptColumnReceiptIndex class]),
    };
}

- (NSString *)valueFromReceipt:(WBReceipt *)receipt inTrip:(WBTrip *)trip receiptIndex:(NSInteger)receiptIndex forCSV:(BOOL)forCSV {
    WB_ABSTRACT_METHOD
    return nil;
}

+ (NSArray *)allColumns {
    return nil;
}

+ (ReceiptColumn *)columnWithIndex:(NSInteger)index name:(NSString *)columnName {
    NSString *columnClassName = __receiptColumnNameToClassMapping[columnName];
    if (!columnClassName) {
        columnClassName = NSStringFromClass([ReceiptUnknownColumn class]);
    }

    Class columnClass = NSClassFromString(columnClassName);
    ReceiptColumn *column = [(ReceiptColumn *) [columnClass alloc] initWithIndex:index name:columnName];
    return column;
}

@end
