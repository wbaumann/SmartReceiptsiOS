//
//  Constants.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 22/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
  static dispatch_once_t pred = 0; \
  __strong static id _sharedObject = nil; \
  dispatch_once(&pred, ^{ \
    _sharedObject = block(); \
  }); \
  return _sharedObject;

#define ABSTRACT_METHOD \
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] \
                                 userInfo:nil];

#if DEBUG
    #define SRLog(s, ...) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
    // A better assert. NSAssert is too runtime dependant, and assert() doesn't log.
    // http://www.mikeash.com/pyblog/friday-qa-2013-05-03-proper-use-of-asserts.html
    // Accepts both:
    // - MCAssert(x > 0);
    // - MCAssert(y > 3, @"Bad value for y");
    #define SRAssert(expression, ...) \
        do { if(!(expression)) { \
            NSLog(@"%@", [NSString stringWithFormat: @"Assertion failure: %s in %s on line %s:%d. %@", #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:@"" __VA_ARGS__]]); \
            abort(); }} while(0)
#else
    #define SRLog(s, ...) //
    #define SRAssert(expression, ...) //
#endif