//
//  DecimalInputValidation.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DecimalInputValidation.h"
#import "WBTextUtils.h"

@interface DecimalInputValidation ()

@property (nonatomic, assign) NSUInteger numberOfDecimalPlaces;

@end

@implementation DecimalInputValidation

- (id)initWithNumberOfDecimalPlaces:(NSUInteger)decimalPlaces {
    self = [super init];
    if (self) {
        _numberOfDecimalPlaces = decimalPlaces;
    }
    return self;
}

- (BOOL)isValidInput:(NSString *)input {
    return [WBTextUtils isDecimalNumber:input decimalPlaces:self.numberOfDecimalPlaces];
}

@end
