//
//  ImagePicker.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 22/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WBImagePickerResultBlock)(UIImage *image);

@interface ImagePicker : NSObject

+ (instancetype)sharedInstance;
- (void)presentPickerOnController:(UIViewController *)controller completion:(WBImagePickerResultBlock)completion;
- (void)presentCameraOnController:(UIViewController *)controller completion:(WBImagePickerResultBlock)completion;

@end
