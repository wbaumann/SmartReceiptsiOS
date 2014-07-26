//
//  WBImageViewController.h
//  SmartReceipts
//
//  Created on 10/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBViewController.h"

#import "WBReceiptsViewController.h"

@interface WBImageViewController : WBViewController<UIScrollViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong) NSString *path;
@property (strong) NSString *name;

@property (weak,nonatomic) WBReceiptsViewController* receiptsViewController;

@property (weak, nonatomic) UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)actionRotateCcw:(id)sender;
- (IBAction)actionRotateCw:(id)sender;
- (IBAction)actionCamera:(id)sender;

@end
