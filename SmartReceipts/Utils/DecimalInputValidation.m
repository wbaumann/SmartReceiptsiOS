//
//  DecimalInputValidation.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/objc.h>
#import "DecimalInputValidation.h"
#import "WBTextUtils.h"

@implementation DecimalInputValidation

- (BOOL)isValidInput:(NSString *)input {
    return [WBTextUtils isMoney:input];
}

@end
