//
//  WBImageUtils.h
//  SmartReceipts
//
//  Created on 04/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBImageUtils : NSObject

+ (UIImage *)image:(UIImage *)image scaledToSize:(CGSize)size;
+ (UIImage *)image:(UIImage *)image scaledToFitSize:(CGSize)size;
+ (UIImage *)image:(UIImage *)image withOrientation:(UIImageOrientation)orientation;
+ (UIImage *)processImage:(UIImage *)image;

@end
