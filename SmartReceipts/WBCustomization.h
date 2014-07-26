//
//  WBCustomization.h
//  SmartReceipts
//
//  Created on 04/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBCustomization : NSObject

+(void) customizeOnAppLoad;

/* Customizes every view controller on load */
+(void) customizeOnViewDidLoad:(UIViewController*) viewController;

@end
