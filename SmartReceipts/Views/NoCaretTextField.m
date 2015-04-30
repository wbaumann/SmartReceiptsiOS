//
//  NoCaretTextField.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "NoCaretTextField.h"

@implementation NoCaretTextField

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    return CGRectZero;
}

@end
