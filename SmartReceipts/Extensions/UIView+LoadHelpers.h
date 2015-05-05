//
//  UIView+LoadHelpers.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LoadHelpers)

+ (instancetype)loadInstance;
+ (UINib *)viewNib;

@end
