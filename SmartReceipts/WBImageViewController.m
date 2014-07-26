//
//  WBImageViewController.m
//  SmartReceipts
//
//  Created on 10/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBImageViewController.h"

#import "HUD.h"
#import "WBAppDelegate.h"

#import "WBImageUtils.h"
#import "WBFileManager.h"
#import "WBPreferences.h"

@interface WBImageViewController ()
{
    UIImage *image;
}
@end

@implementation WBImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.name;
    
    image = [UIImage imageWithContentsOfFile:self.path];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
    self.imageView = tempImageView;
    [self.scrollView addSubview:tempImageView];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = nil;
    
    self.scrollView.bouncesZoom = YES;
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.minimumZoomScale = 1;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshSizes];
}

- (void)refreshSizes {
    self.imageView.frame = self.scrollView.bounds;
    self.imageView.image = image;
    
    self.scrollView.contentSize = self.scrollView.bounds.size;
    self.scrollView.contentOffset = CGPointMake(0, 0);
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self refreshSizes];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)rotateToOrientation:(UIImageOrientation)orientation {
    [HUD showUIBlockingIndicatorWithText:@""];
    
    [self.scrollView zoomToRect:self.scrollView.bounds animated:NO];
    image = [WBImageUtils image:image withOrientation:orientation];
    
    dispatch_async([[WBAppDelegate instance] dataQueue], ^{
        NSData *data;
        if([[self.path pathExtension] caseInsensitiveCompare:@"png"] == NSOrderedSame) {
            data = UIImagePNGRepresentation(image);
        } else {
            data = UIImageJPEGRepresentation(image, 0.85);
        }
        
        [WBFileManager forceWriteData:data to:self.path];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshSizes];
            [HUD hideUIBlockingIndicator];
        });
    });
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    int size = [WBPreferences cameraMaxHeightWidth];
    if (size > 0) {
        chosenImage = [WBImageUtils image:chosenImage scaledToFitSize:CGSizeMake(size, size)];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (chosenImage) {
            image = chosenImage;
            
            NSData *data;
            if([[self.path pathExtension] caseInsensitiveCompare:@"png"] == NSOrderedSame) {
                data = UIImagePNGRepresentation(image);
            } else {
                data = UIImageJPEGRepresentation(image, 0.85);
            }
            
            [WBFileManager forceWriteData:data to:self.path];
            
            [self refreshSizes];
        }
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)actionRotateCcw:(id)sender {
    [self rotateToOrientation:UIImageOrientationLeft];
}

- (IBAction)actionRotateCw:(id)sender {
    [self rotateToOrientation:UIImageOrientationRight];
}

- (IBAction)actionCamera:(id)sender {
    [WBReceiptsViewController takePhotoWithViewController:self];
}
@end
