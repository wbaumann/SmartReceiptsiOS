//
//  ProperNameInputValidation.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 15/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ProperNameInputValidation.h"
#import "WBTextUtils.h"

@implementation ProperNameInputValidation

- (BOOL)isValidInput:(NSString *)input {
    return [WBTextUtils isProperName:input];
}

@end
