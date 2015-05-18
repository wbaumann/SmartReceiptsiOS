//
//  WBPreferences.h
//  SmartReceipts
//
//  Created on 27/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBPreferences : NSObject

+ (BOOL)predictCategories;
+ (void)setPredictCategories:(BOOL)predictCategories;

+ (BOOL)matchCommentToCategory;
+ (void)setMatchCommentToCategory:(BOOL)matchCommentToCategory;

+ (BOOL)matchNameToCategory;
+ (void)setMatchNameToCategory:(BOOL)matchNameToCategory;

+ (BOOL)onlyIncludeExpensableReceiptsInReports;
+ (void)setOnlyIncludeExpensableReceiptsInReports:(BOOL)onlyIncludeExpensableReceiptsInReports;

+ (BOOL)includeTaxField;
+ (void)setIncludeTaxField:(BOOL)includeTaxField;

+ (NSString *)dateSeparator;
+ (void)setDateSeparator:(NSString *)dateSeparator;

+ (BOOL)enableAutoCompleteSuggestions;
+ (void)setEnableAutoCompleteSuggestions:(BOOL)enableAutoCompleteSuggestions;

+ (NSString *)defaultEmailReceipient;
+ (void)setDefaultEmailReceipient:(NSString *)defaultEmailReceipient;

+ (NSString *)defaultCurrency;
+ (void)setDefaultCurrency:(NSString *)defaultCurrency;

+ (NSString *)userID;
+ (void)setUserID:(NSString *)userID;

+ (int)defaultTripDuration;
+ (void)setDefaultTripDuration:(int)defaultTripDuration;

+ (float)minimumReceiptPriceToIncludeInReports;
+ (void)setMinimumReceiptPriceToIncludeInReports:(float)minimumReceiptPriceToIncludeInReports;

+ (BOOL)defaultToFirstReportDate;
+ (void)setDefaultToFirstReportDate:(BOOL)defaultToFirstReportDate;

+ (BOOL)includeCSVHeaders;
+ (void)setIncludeCSVHeaders:(BOOL)includeCSVHeaders;

+ (BOOL)isTheDistancePriceBeIncludedInReports;
+ (void)setTheDistancePriceBeIncludedInReports:(BOOL)value;

+ (float)distanceRateDefaultValue;
+ (void)setDistanceRateDefaultValue:(float)value;

+ (BOOL)printDistanceTable;
+ (void)setPrintDistanceTable:(BOOL)value;

+ (BOOL)printDailyDistanceValues;
+ (void)setPrintDailyDistanceValues:(BOOL)value;

+ (BOOL)usePaymentMethods;
+ (void)setUsePaymentMethods:(BOOL)value;

+ (BOOL)trackCostCenter;
+ (void)setTrackCostCenter:(BOOL)value;

+ (int)cameraMaxHeightWidth;
+ (void)setCameraMaxHeightWidth:(int)cameraMaxHeightWidth;

+ (void)save;

+ (float)MIN_FLOAT;

+ (void)setFromXmlString:(NSString *)xmlString;
+ (NSString *)xmlString;

@end
