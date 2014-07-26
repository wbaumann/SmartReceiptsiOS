//
//  WBAppDelegate.h
//  SmartReceipts
//
//  Created on 11/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *filePathToAttach;
@property BOOL isFileImage;

- (dispatch_queue_t) dataQueue;

- (void) freeFilePathToAttach;

+ (WBAppDelegate*) instance;

@end
