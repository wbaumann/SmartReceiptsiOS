//
//  UIView+Search.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "UIView+Search.h"

@implementation UIView (Search)

- (UIView *)superviewOfType:(Class)superClass {
    UIView *checked = [self superview];
    while (checked) {
        if ([checked isKindOfClass:superClass]) {
            return checked;
        }

        checked = [checked superview];
    }
    return nil;
}

@end
