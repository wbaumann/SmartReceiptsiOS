//
//  WBCurrency.h
//  SmartReceipts
//
//  Created on 14/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBCurrency: NSObject <NSCoding>

@property (readonly, nonatomic, copy) NSString *code;

+ (NSArray *)iso4217CurrencyCodes;
+ (NSArray *)nonIso4217CurrencyCodes;
+ (NSArray *)allCurrencyCodes;
+ (WBCurrency *)currencyForCode:(NSString*) currencyCode;

@end
