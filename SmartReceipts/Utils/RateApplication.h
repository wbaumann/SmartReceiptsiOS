//
//  RateApplication.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 13/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RateApplication : NSObject

+ (instancetype)sharedInstance;

- (void)markAppLaunch;
- (void)markAppCrash;

@end
