//
//  ReceiptColumnCategoryCode.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/NSObjCRuntime.h>
#import <objc/objc.h>
#import "ReceiptColumnCategoryCode.h"
#import "WBReceipt.h"
#import "WBTrip.h"
#import "WBDB.h"

@interface ReceiptColumnCategoryCode ()

@property (nonatomic, strong) NSDictionary *categoriesMap;

@end

@implementation ReceiptColumnCategoryCode

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    return self.categoriesMap[[receipt category]];
}


- (NSDictionary *)categoriesMap {
    if (!_categoriesMap) {
        NSArray *categories = [[WBDB categories] selectAll];
        _categoriesMap = [WBCategory namesToCodeMapFromCategories:categories];
    }
    return _categoriesMap;
}

@end
