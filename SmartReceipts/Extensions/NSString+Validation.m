//
//  NSString+Validation.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "NSString+Validation.h"
#import "NSString+Helpers.h"

@implementation NSString (Validation)

- (BOOL)hasValue {
    return [self trimmedString].length > 0;
}

@end
