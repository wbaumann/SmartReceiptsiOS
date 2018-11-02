//
//  LoggerMacros-ObjC.h
//  SmartReceipts
//
//  Created by Victor on 1/16/17.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

#import <SmartReceipts-Swift.h>

#ifndef LoggerMacros_ObjC_h
#define LoggerMacros_ObjC_h

/// Objective-C wrappers for Logger.swift methods, for passing additional parameters: _line_, _function_, _file_

#pragma mark - Wrappers

#define LOGGER_VERBOSE(s, ...) [Logger verbose:[NSString stringWithFormat:(s), ##__VA_ARGS__] file:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) line:__LINE__]
#define LOGGER_DEBUG(s, ...) [Logger debug:[NSString stringWithFormat:(s), ##__VA_ARGS__] file:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) line:__LINE__]
#define LOGGER_INFO(s, ...) [Logger info:[NSString stringWithFormat:(s), ##__VA_ARGS__] file:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) line:__LINE__]
#define LOGGER_WARNING(s, ...) [Logger warning:[NSString stringWithFormat:(s), ##__VA_ARGS__] file:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) line:__LINE__]
#define LOGGER_ERROR(s, ...) [Logger error:[NSString stringWithFormat:(s), ##__VA_ARGS__] file:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] function:NSStringFromSelector(_cmd) line:__LINE__]

#pragma mark - Assert:

// Note: Swift assertions are debug-only, Swift assertions will be logged automatically by onUncaughtException method in AppDelegate
#if DEBUG
    // A better assert. NSAssert is too runtime dependant, and assert() doesn't log.
    // http://www.mikeash.com/pyblog/friday-qa-2013-05-03-proper-use-of-asserts.html
    // Accepts both:
    // - MCAssert(x > 0);
    // - MCAssert(y > 3, @"Bad value for y");
    #define WBAssertLoggable(expression, ...) \
        do { if(!(expression)) { \
        LOGGER_ERROR(@"%@", [NSString stringWithFormat: @"Assertion failure: %s in %s on line %s:%d. %@", #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:@"" __VA_ARGS__]]); \
        abort(); }} while(0)
#else
    // Apple recommends to disable assertions on Production:
    // https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html
    #define WBAssertLoggable(expression, ...)
#endif

#endif /* LoggerMacros_ObjC_h */







#pragma mark - Notes:

/*
 May be helpful in future:
 
 | Expression                       | Format   | Description
 NSStringFromSelector(_cmd)         %@         Name of the current selector
 NSStringFromClass([self class])    %@         Current object's class name
 [[NSString                         %@         Source code file name
 stringWithUTF8String:__FILE__]
 lastPathComponent]
 [NSThread callStackSymbols]        %@         NSArray of stack trace
 */
