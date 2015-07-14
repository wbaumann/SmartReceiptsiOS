//
//  WBCustomization.m
//  SmartReceipts
//
//  Created on 04/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBCustomization.h"

@implementation WBCustomization

+ (UIColor *)themeColor {
    return [UIColor colorWithRed:(148 / 255.0) green:(0 / 255.0) blue:(211 / 255.0) alpha:1.0];
}

+ (void)customizeOnAppLoad {

    // back button
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    // bar background
    [[UINavigationBar appearance] setBarTintColor:[WBCustomization themeColor]];

    // title color
    [[UINavigationBar appearance]
            setTitleTextAttributes:@{
                    NSForegroundColorAttributeName : [UIColor whiteColor]
            }
    ];

    [[UIToolbar appearance] setTintColor:[WBCustomization themeColor]];

}

+ (UIColor *)reportPDFStyleColor {
    return [UIColor colorWithRed:(0 / 255.f) green:(122 / 255.f) blue:(255 / 255.f) alpha:1.0];
}

+ (void)customizeOnViewDidLoad:(UIViewController *)viewController {
    UINavigationController *navigationController = viewController.navigationController;
    if (navigationController) {
        // configure navigation bar here, to do some more fancy things
    }

    // changes color of active elements like buttons and segments, unfortunately alertview cannot be costumized
    [[UIApplication sharedApplication] keyWindow].tintColor = [WBCustomization themeColor];

    // chanes status bar color, however iOS built-in controllers (for example mail composer) may override it
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
