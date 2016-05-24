//
//  WBReceipt.h
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/objc.h>
#import "FetchedModel.h"

@class WBTrip, WBCurrency;
@class Price;
@class PaymentMethod;

@interface WBReceipt : NSObject <FetchedModel>

@property (nonatomic, assign) NSUInteger objectId;
@property (nonatomic, strong) Price *price;
@property (nonatomic, strong) Price *tax;
@property (nonatomic, strong) WBTrip *trip;
@property (nonatomic, assign) NSInteger reportIndex;
@property (nonatomic, strong) PaymentMethod *paymentMethod;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tripName;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, strong) NSTimeZone *timeZone;
@property (nonatomic, assign, getter=isExpensable) BOOL expensable;
@property (nonatomic, assign, getter=isFullPage) BOOL fullPage;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *comment;

- (id)initWithId:(NSUInteger)rid
            name:(NSString *)name
        category:(NSString *)category
   imageFileName:(NSString *)imageFileName
            date:(NSDate *)date
    timeZoneName:(NSString *)timeZoneName
         comment:(NSString *)comment
           price:(Price *)price
             tax:(Price *)tax
    isExpensable:(BOOL)isExpensable
      isFullPage:(BOOL)isFullPage
  extraEditText1:(NSString *)extraEditText1
  extraEditText2:(NSString *)extraEditText2
  extraEditText3:(NSString *)extraEditText3;

-(NSUInteger)receiptId;
-(NSString*)imageFileName;
-(NSTimeZone*)timeZone;

-(NSString*)name;
-(NSString*)category;
- (NSString *)priceAsString;
- (NSString *)taxAsString;
- (NSDecimalNumber *)priceAmount;
-(WBCurrency*)currency;
-(BOOL)isExpensable;
-(BOOL)isFullPage;
-(NSString*)extraEditText1;
-(NSString*)extraEditText2;
-(NSString*)extraEditText3;

-(void)setImageFileName:(NSString*)imageFileName;

// we don't store trip so we pass it as argument

-(NSString*)imageFilePathForTrip:(WBTrip*)trip;
-(BOOL)hasFileForTrip:(WBTrip*)trip;

- (BOOL)hasImage;
- (BOOL)hasPDF;

-(BOOL)hasImageFileName;
-(BOOL)hasPDFFileName;

-(NSString*)priceWithCurrencyFormatted;
-(NSString*)taxWithCurrencyFormatted;

-(BOOL)hasExtraEditText1;
-(BOOL)hasExtraEditText2;
-(BOOL)hasExtraEditText3;

- (NSString *)attachmentMarker;

@end
