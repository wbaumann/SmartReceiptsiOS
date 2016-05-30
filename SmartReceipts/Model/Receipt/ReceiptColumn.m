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
#import "ReceiptColumnBlank.h"
#import "ReceiptColumnCategoryCode.h"
#import "ReceiptColumnCategoryName.h"
#import "ReceiptColumnUserID.h"
#import "ReceiptColumnReportName.h"
#import "ReceiptColumnReportStartDate.h"
#import "ReceiptColumnReportEndDate.h"
#import "ReceiptColumnImageName.h"
#import "ReceiptColumnImagePath.h"
#import "ReceiptColumnComment.h"
#import "ReceiptColumnCurrency.h"
#import "ReceiptColumnDate.h"
#import "ReceiptColumnName.h"
#import "ReceiptColumnPrice.h"
#import "ReceiptColumnPictured.h"
#import "ReceiptColumnExpensable.h"
#import "ReceiptColumnReceiptIndex.h"
#import "ReceiptUnknownColumn.h"
#import "ReceiptColumnPaymentMethod.h"
#import "ReceiptColumnReportComment.h"
#import "ReceiptColumnReportCostCenter.h"
#import "SmartReceipts-Swift.h"

// Extras have to be filled to be active.
NSString *const WBColumnNameExtraEdittext1 = @"";
NSString *const WBColumnNameExtraEdittext2 = @"";
NSString *const WBColumnNameExtraEdittext3 = @"";


static NSDictionary *__receiptColumnNameToClassMapping;

@implementation ReceiptColumn

+ (void)initialize {
    __receiptColumnNameToClassMapping = @{
            NSLocalizedString(@"receipt.column.blank.column", nil) : NSStringFromClass([ReceiptColumnBlank class]),
            NSLocalizedString(@"receipt.column.category.code", nil) : NSStringFromClass([ReceiptColumnCategoryCode class]),
            NSLocalizedString(@"receipt.column.category.name", nil) : NSStringFromClass([ReceiptColumnCategoryName class]),
            NSLocalizedString(@"receipt.column.user.id", nil) : NSStringFromClass([ReceiptColumnUserID class]),
            NSLocalizedString(@"receipt.column.report.name", nil) : NSStringFromClass([ReceiptColumnReportName class]),
            NSLocalizedString(@"receipt.column.report.start.date", nil) : NSStringFromClass([ReceiptColumnReportStartDate class]),
            NSLocalizedString(@"receipt.column.report.end.date", nil) : NSStringFromClass([ReceiptColumnReportEndDate class]),
            NSLocalizedString(@"receipt.column.image.name", nil) : NSStringFromClass([ReceiptColumnImageName class]),
            NSLocalizedString(@"receipt.column.image.path", nil) : NSStringFromClass([ReceiptColumnImagePath class]),
            NSLocalizedString(@"receipt.column.comment", nil) : NSStringFromClass([ReceiptColumnComment class]),
            NSLocalizedString(@"receipt.column.currency", nil) : NSStringFromClass([ReceiptColumnCurrency class]),
            NSLocalizedString(@"receipt.column.date", nil) : NSStringFromClass([ReceiptColumnDate class]),
            NSLocalizedString(@"receipt.column.name", nil) : NSStringFromClass([ReceiptColumnName class]),
            NSLocalizedString(@"receipt.column.price", nil) : NSStringFromClass([ReceiptColumnPrice class]),
            NSLocalizedString(@"receipt.column.tax", nil) : NSStringFromClass([ReceiptColumnTax class]),
            NSLocalizedString(@"receipt.column.pictured", nil) : NSStringFromClass([ReceiptColumnPictured class]),
            NSLocalizedString(@"receipt.column.expensable", nil) : NSStringFromClass([ReceiptColumnExpensable class]),
            NSLocalizedString(@"receipt.column.receipt.index", nil) : NSStringFromClass([ReceiptColumnReceiptIndex class]),
            NSLocalizedString(@"receipt.column.payment.method", nil) : NSStringFromClass([ReceiptColumnPaymentMethod class]),
            NSLocalizedString(@"receipt.column.report.comment", nil) : NSStringFromClass([ReceiptColumnReportComment class]),
            NSLocalizedString(@"receipt.column.report.cost.center", nil) : NSStringFromClass([ReceiptColumnReportCostCenter class]),
            NSLocalizedString(@"receipt.column.report.exchange.rate", nil) : NSStringFromClass([ReceiptColumnExchangeRate class]),
            NSLocalizedString(@"receipt.column.report.exchanged.price", nil) : NSStringFromClass([ReceiptColumnExchangedPrice class]),
            NSLocalizedString(@"receipt.column.report.exchanged.tax", nil) : NSStringFromClass([ReceiptColumnExchangedTax class]),
            NSLocalizedString(@"receipt.column.report.exchanged.price.plus.tax", nil) : NSStringFromClass([ReceiptColumnNetExchangedPricePlusTax class]),
    };
}

- (NSString *)valueFromRow:(id)row forCSV:(BOOL)forCVS {
    return [self valueFromReceipt:row forCSV:forCVS];
}

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    ABSTRACT_METHOD
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

+ (NSArray *)availableColumnsNames {
    NSMutableArray *arr = [__receiptColumnNameToClassMapping keyEnumerator].allObjects.mutableCopy;

    [arr sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    NSArray *optional = @[WBColumnNameExtraEdittext1, WBColumnNameExtraEdittext2, WBColumnNameExtraEdittext3];

    for (NSString *str in optional) {
        if (str.length > 0) {
            [arr addObject:str];
        }
    }

    return arr;
}

@end
