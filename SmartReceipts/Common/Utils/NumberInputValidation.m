//
//  NumberInputValidation.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "NumberInputValidation.h"
#import "WBTextUtils.h"

@implementation NumberInputValidation

- (BOOL)isValidInput:(NSString *)input {
    return [WBTextUtils isNonnegativeInteger:input];
}

@end
