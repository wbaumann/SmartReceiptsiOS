//
//  TaxCalculator.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 23/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/objc.h>

@interface TaxCalculator : NSObject

@property (nonatomic, assign) BOOL priceIsPreTax;
@property (nonatomic, strong) NSDecimalNumber *taxPercentage;

- (id)initWithSourceField:(UITextField *)priceField targetField:(UITextField *)taxField;

@end
