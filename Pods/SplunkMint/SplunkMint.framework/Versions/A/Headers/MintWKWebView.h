//
//  MintWKWebView.h
//  SplunkMint
//
//  Copyright (c) 2016 Splunk. All rights reserved.
//

#import <WebKit/WebKit.h>

/**
 The **MintWKWebView** class is a custom web view that automatically enables JavaScript tracking,
 which allows the MINT SDKs to access hybrid (non-native) web pages and gain visibility into
 these functions.
 */
@interface MintWKWebView : WKWebView

/*!
 @abstract Initializes with a frame rectangle and configuration.
 @param frame The rectangle frame for initial size and placement.
 @param configuration A **WKWebViewConfiguration** object, which is a collection of properties with
 which to initialize a web view.
 */
- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration;

/*!
 @abstract Initializes with a frame rectangle.
 @param frame The rectangle frame for initial size and placement.
 */
- (instancetype)initWithFrame:(CGRect)frame;

@end
