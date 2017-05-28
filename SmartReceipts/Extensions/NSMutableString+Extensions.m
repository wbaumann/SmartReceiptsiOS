//
//  NSMutableString+Extensions.m
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 28/05/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

#import "NSMutableString+Extensions.h"
#import "NSString+Extensions.h"

@implementation NSMutableString (Extensions)

+ (NSMutableString *)mutableStringWithByteOrderMark {
    return [NSMutableString stringWithString:[NSString stringWithByteOrderMark]];
}

@end
