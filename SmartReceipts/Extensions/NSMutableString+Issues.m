//
//  NSMutableString+Issues.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "NSMutableString+Issues.h"

@implementation NSMutableString (Issues)

- (void)appendIssue:(NSString *)issue {
    if (self.length > 0) {
        [self appendString:@"\n"];
    }

    [self appendFormat:@"• %@", issue];
}

@end
