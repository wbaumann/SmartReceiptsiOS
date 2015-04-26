//
//  WBReceipt.h
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBTrip, WBCurrency;
@class WBPrice;

@interface WBReceipt : NSObject

@property (nonatomic, strong, readonly) WBPrice *price;
@property (nonatomic, strong, readonly) WBPrice *tax;
@property (nonatomic, strong) WBTrip *trip;
@property (nonatomic, assign) NSInteger reportIndex;


+(NSString*) NO_DATA;

- (id)initWithId:(int)rid
            name:(NSString *)name
        category:(NSString *)category
   imageFileName:(NSString *)imageFileName
          dateMs:(long long)dateMs
    timeZoneName:(NSString *)timeZoneName
         comment:(NSString *)comment
           price:(WBPrice *)price
             tax:(WBPrice *)tax
    isExpensable:(BOOL)isExpensable
      isFullPage:(BOOL)isFullPage
  extraEditText1:(NSString *)extraEditText1
  extraEditText2:(NSString *)extraEditText2
  extraEditText3:(NSString *)extraEditText3;

-(int)receiptId;
-(NSString*)imageFileName;
-(long long)dateMs;
-(NSTimeZone*)timeZone;

-(NSString*)name;
-(NSString*)category;
-(NSString*)comment;
- (NSString *)priceAsString;
- (NSString *)taxAsString;
- (NSDecimalNumber *)priceAmount;
-(NSDecimalNumber*)tax_as_nsdecnum;
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
