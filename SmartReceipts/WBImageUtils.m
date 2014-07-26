//
//  WBImageUtils.m
//  SmartReceipts
//
//  Created on 04/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBImageUtils.h"

static inline double radians (double degrees) {
    return degrees * M_PI/180;
}

@implementation WBImageUtils

+ (UIImage *)image:(UIImage*) image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0f);
    
    [image drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)image:(UIImage*) image scaledToFitSize:(CGSize)size
{
    CGFloat aspect = image.size.width / image.size.height;
    if (size.width / aspect <= size.height)
    {
        return [WBImageUtils image:image scaledToSize:CGSizeMake(size.width, size.width / aspect)];
    }
    else
    {
        return [WBImageUtils image:image scaledToSize:CGSizeMake(size.height * aspect, size.height)];
    }
}

+ (UIImage *)image:(UIImage*) image withOrientation:(UIImageOrientation) orientation {
    CGSize size = image.size;
    UIGraphicsBeginImageContext(CGSizeMake(size.height, size.width));
    
    [[UIImage imageWithCGImage:[image CGImage] scale:1.0 orientation:orientation] drawInRect:CGRectMake(0,0,size.height ,size.width)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
