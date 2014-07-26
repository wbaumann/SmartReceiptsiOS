//
//  WBReceipt.h
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBTrip, WBCurrency;

@interface WBReceipt : NSObject

+(NSString*) NO_DATA;

- (id)initWithId:(int)rid
            name:(NSString*)name
        category:(NSString*)category
   imageFileName:(NSString*)imageFileName
          dateMs:(long long)dateMs
    timeZoneName:(NSString*)timeZoneName
         comment:(NSString*)comment
           price:(NSString*)price
             tax:(NSString*)tax
    currencyCode:(NSString*)currencyCode
    isExpensable:(BOOL)isExpensable
      isFullPage:(BOOL)isFullPage
  extraEditText1:(NSString*)extraEditText1
  extraEditText2:(NSString*)extraEditText2
  extraEditText3:(NSString*)extraEditText3
;

-(int)receiptId;
-(NSString*)imageFileName;
-(long long)dateMs;
-(NSTimeZone*)timeZone;

-(NSString*)name;
-(NSString*)category;
-(NSString*)comment;
-(NSString*)price;
-(NSString*)tax;
-(WBCurrency*)currency;
-(BOOL)isExpensable;
-(BOOL)isFullPage;
-(NSString*)extraEditText1;
-(NSString*)extraEditText2;
-(NSString*)extraEditText3;

-(NSDate*) dateFromDateMs;

-(void)setImageFileName:(NSString*)imageFileName;

// we don't store trip so we pass it as argument

-(NSString*)imageFilePathForTrip:(WBTrip*)trip;
-(BOOL)hasFileForTrip:(WBTrip*)trip;

-(BOOL)hasImageForTrip:(WBTrip*)trip;
-(BOOL)hasPDFForTrip:(WBTrip*)trip;

-(BOOL)hasImageFileName;
-(BOOL)hasPDFFileName;

-(void)setDateMs:(long long) dateMs;

-(NSString*)priceWithCurrencyFormatted;
-(NSString*)taxWithCurrencyFormatted;

-(BOOL)hasExtraEditText1;
-(BOOL)hasExtraEditText2;
-(BOOL)hasExtraEditText3;

@end
