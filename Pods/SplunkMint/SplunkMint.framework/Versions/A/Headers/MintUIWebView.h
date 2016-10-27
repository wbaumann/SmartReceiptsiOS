//
//  MintUIWebView.h
//  SplunkMint
//
//  Copyright (c) 2016 Splunk. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The **MintUIWebView** class is a custom web view that automatically enables JavaScript tracking,
 which allows the MINT SDKs to access hybrid (non-native) web pages and gain visibility into
 these functions.
 */
@interface MintUIWebView : UIWebView

/*!
 @abstract Initializes for NSCoding.
 @param aDecoder An **NSCoder** instance for data population.
 */
- (id) initWithCoder:(NSCoder *)aDecoder;

/*!
 @abstract Initializes with a frame rectangle.
 @param frame The rectangle frame for initial size and placement.
 */
- (id) initWithFrame:(CGRect)frame;

/*!
 @abstract Sets the delegate for event callbacks.
 @param delegate The **UIWebViewDelegate** to use for event callbacks.
 */
- (void) setDelegate:(id<UIWebViewDelegate>)delegate;

@end
