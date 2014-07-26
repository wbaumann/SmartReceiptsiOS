//
//  WBDateUtils.h
//  SmartReceipts
//
//  Created on 30/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Date formatter customized for SmartReceipts app.
 */

@interface WBDateFormatter : NSObject

-(NSString*) formattedDate:(NSDate*) date inTimeZone:(NSTimeZone*) timeZone;
-(NSString*) formattedDateMs:(long long)dateMs inTimeZone:(NSTimeZone*) timeZone;

-(NSString*) separatorForCurrentLocale;

@end
