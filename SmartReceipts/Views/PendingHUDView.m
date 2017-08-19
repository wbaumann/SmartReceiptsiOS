//
//  PendingHUDView.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 23/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "PendingHUDView.h"

#if DEBUG
static BOOL isRunningTests(void) {
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *injectBundle = environment[@"XCInjectBundle"];
    return [[injectBundle pathExtension] isEqualToString:@"xctest"];
}
#endif

@implementation PendingHUDView

+ (PendingHUDView *)showHUDOnView:(UIView *)view {
    PendingHUDView *overlayView = [[PendingHUDView alloc] init];
    [overlayView setTitleLabelText:@""];
    BOOL testing = NO;
#if DEBUG
    testing = isRunningTests();
#endif
    if (!testing) {
        //TODO jaanus: when executing tests overlayView is nil and crashes. Not sure why
        [view addSubview:overlayView];
    }
    [overlayView show:YES];
    [overlayView setTintColor:[AppTheme primaryColor]];
    return overlayView;
}

- (void)hide {
    [self dismiss:YES];
}

@end
