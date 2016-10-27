//
//  MintJavascript.h
//  SplunkMint
//
//  Copyright (c) 2016 Splunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MintJavascript : NSObject
- (void)execute:(NSString*)functionName data:(id)data;
@end
