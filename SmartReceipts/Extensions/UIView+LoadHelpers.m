//
//  UIView+LoadHelpers.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "UIView+LoadHelpers.h"

static NSString *const kModulePrefix = @"SmartReceipts.";

@implementation UIView (LoadHelpers)

+ (instancetype)loadInstance {
    NSString *expectedNibName = NSStringFromClass([self class]);
    return [UIView loadViewFromXib:expectedNibName];
}

+ (UIView *)loadViewFromXib:(NSString *)xibName {
    UIView *result = nil;
    NSString *xib = [xibName stringByReplacingOccurrencesOfString:kModulePrefix withString:@""];
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:xib owner:nil options:nil];
    for (id currentObject in topLevelObjects) {
        if ([currentObject isKindOfClass:[UIView class]]) {
            result = (UIView *) currentObject;
            break;
        }
    }

    return result;
}

+ (UINib *)viewNib {
    NSString *expectedNibName = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:kModulePrefix withString:@""];
    return [UINib nibWithNibName:expectedNibName bundle:nil];
}

@end
