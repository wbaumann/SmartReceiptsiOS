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
#import "ReceiptColumnPictured.h"
#import "ReceiptColumnReimbursable.h"
#import "ReceiptColumnReceiptIndex.h"
#import "ReceiptUnknownColumn.h"
#import "ReceiptColumnPaymentMethod.h"
#import "ReceiptColumnReportComment.h"
#import "ReceiptColumnReportCostCenter.h"
#import "SmartReceipts-Swift.h"
#import "LocalizedString.h"

// Extras have to be filled to be active.
NSString *const WBColumnNameExtraEdittext1 = @"";
NSString *const WBColumnNameExtraEdittext2 = @"";
NSString *const WBColumnNameExtraEdittext3 = @"";


static NSDictionary *__receiptColumnNameToClassMapping;

@implementation ReceiptColumn

+ (void)initialize {
    __receiptColumnNameToClassMapping = @{
            LocalizedString(@"column_item_blank", nil) : NSStringFromClass([ReceiptColumnBlank class]),
            LocalizedString(@"column_item_category_code", nil) : NSStringFromClass([ReceiptColumnCategoryCode class]),
            LocalizedString(@"column_item_category_name", nil) : NSStringFromClass([ReceiptColumnCategoryName class]),
            LocalizedString(@"pref_output_username_title", nil) : NSStringFromClass([ReceiptColumnUserID class]),
            LocalizedString(@"column_item_report_name", nil) : NSStringFromClass([ReceiptColumnReportName class]),
            LocalizedString(@"column_item_report_start_date", nil) : NSStringFromClass([ReceiptColumnReportStartDate class]),
            LocalizedString(@"column_item_report_end_date", nil) : NSStringFromClass([ReceiptColumnReportEndDate class]),
            LocalizedString(@"column_item_image_file_name", nil) : NSStringFromClass([ReceiptColumnImageName class]),
            LocalizedString(@"column_item_image_path", nil) : NSStringFromClass([ReceiptColumnImagePath class]),
            LocalizedString(@"RECEIPTMENU_FIELD_COMMENT", nil) : NSStringFromClass([ReceiptColumnComment class]),
            LocalizedString(@"RECEIPTMENU_FIELD_CURRENCY", nil) : NSStringFromClass([ReceiptColumnCurrency class]),
            LocalizedString(@"RECEIPTMENU_FIELD_DATE", nil) : NSStringFromClass([ReceiptColumnDate class]),
            LocalizedString(@"RECEIPTMENU_FIELD_NAME", nil) : NSStringFromClass([ReceiptColumnName class]),
            LocalizedString(@"RECEIPTMENU_FIELD_PRICE", nil) : NSStringFromClass([ReceiptColumnPrice class]),
            LocalizedString(@"RECEIPTMENU_FIELD_TAX", nil) : NSStringFromClass([ReceiptColumnTax class]),
            LocalizedString(@"column_item_pictured", nil) : NSStringFromClass([ReceiptColumnPictured class]),
            LocalizedString(@"graphs_label_reimbursable", nil) : NSStringFromClass([ReceiptColumnReimbursable class]),
            LocalizedString(@"column_item_index", nil) : NSStringFromClass([ReceiptColumnReceiptIndex class]),
            LocalizedString(@"payment_method", nil) : NSStringFromClass([ReceiptColumnPaymentMethod class]),
            LocalizedString(@"column_item_report_comment", nil) : NSStringFromClass([ReceiptColumnReportComment class]),
            LocalizedString(@"column_item_report_cost_center", nil) : NSStringFromClass([ReceiptColumnReportCostCenter class]),
            LocalizedString(@"column_item_exchange_rate", nil) : NSStringFromClass([ReceiptColumnExchangeRate class]),
            LocalizedString(@"column_item_converted_price_exchange_rate", nil) : NSStringFromClass([ReceiptColumnExchangedPrice class]),
            LocalizedString(@"column_item_converted_tax_exchange_rate", nil) : NSStringFromClass([ReceiptColumnExchangedTax class]),
            LocalizedString(@"column_item_converted_price_plus_tax_exchange_rate", nil) : NSStringFromClass([ReceiptColumnNetExchangedPricePlusTax class]),
            LocalizedString(@"column_item_id", nil) : NSStringFromClass([ReceiptColumnReceiptId class]),
            LocalizedString(@"column_item_receipt_price_minus_tax", nil) : NSStringFromClass([ReceiptColumnPriceMinusTax class]),
            LocalizedString(@"column_item_converted_price_minus_tax_exchange_rate", nil) : NSStringFromClass([ReceiptColumnExchangedPriceMinusTax class]),
    };
}

- (NSString *)valueFromRow:(id)row forCSV:(BOOL)forCVS {
    return [self valueFromReceipt:row forCSV:forCVS];
}

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    ABSTRACT_METHOD
    return nil;
}

- (NSString *)valueForFooter:(NSArray *)rows forCSV:(BOOL)forCSV {
    return @"";
}

+ (ReceiptColumn *)columnName:(NSString *)columnName {
    return [ReceiptColumn columnWithIndex:-1 name:columnName];
}

+ (ReceiptColumn *)columnWithIndex:(NSInteger)index name:(NSString *)columnName {
    // for compability.
    // legacy string, expensable was renamed to reimbursable
    if ([columnName isEqualToString:LocalizedString(@"column_item_deprecated_expensable", nil)]) {
        columnName = LocalizedString(@"graphs_label_reimbursable", nil);
    }
    
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
