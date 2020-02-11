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

+ (BOOL)onlyIncludeReimbursableReceiptsInReports;
+ (void)setOnlyIncludeReimbursableReceiptsInReports:(BOOL)onlyIncludeReimbursableReceiptsInReports;
    
+ (BOOL)expensableDefault;
+ (void)setExpensableDefault:(BOOL)expensableDefault;

+ (BOOL)includeTaxField;
+ (void)setIncludeTaxField:(BOOL)includeTaxField;

+ (NSString *)dateFormat;
+ (void)setDateFormat:(NSString *)dateFormat;

+ (NSString *)defaultEmailRecipient;
+ (void)setDefaultEmailRecipient:(NSString *)defaultEmailReceipient;

+ (NSString *)defaultEmailCC;
+ (void)setDefaultEmailCC:(NSString *)value;

+ (NSString *)defaultEmailBCC;
+ (void)setDefaultEmailBCC:(NSString *)value;

+ (NSString *)defaultEmailSubject;
+ (void)setDefaultEmailSubject:(NSString *)value;

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

+ (BOOL)isTheDistancePriceBeIncludedInReports;
+ (void)setTheDistancePriceBeIncludedInReports:(BOOL)value;

+ (double)distanceRateDefaultValue;
+ (void)setDistanceRateDefaultValue:(double)value;

+ (float)defaultTaxPercentage;
+ (void)setDefaultTaxPercentage:(float)value;

+ (BOOL)enteredPricePreTax;
+ (void)setEnteredPricePreTax:(BOOL)value;

+ (BOOL)printDistanceTable;
+ (void)setPrintDistanceTable:(BOOL)value;

+ (BOOL)printDailyDistanceValues;
+ (void)setPrintDailyDistanceValues:(BOOL)value;

+ (BOOL)usePaymentMethods;
+ (void)setUsePaymentMethods:(BOOL)value;

+ (BOOL)trackCostCenter;
+ (void)setTrackCostCenter:(BOOL)value;

+ (BOOL)showReceiptID;
+ (void)setShowReceiptID:(BOOL)value;

+ (BOOL)printReceiptIDByPhoto;
+ (void)setPrintReceiptIDByPhoto:(BOOL)value;

+ (BOOL)printCommentByPhoto;
+ (void)setPrintCommentByPhoto:(BOOL)value;

+ (BOOL)printReceiptTableLandscape;
+ (void)setPrintReceiptTableLandscape:(BOOL)value;

+ (NSString *)preferredRawPDFSize;
+ (void)setPreferredRawPDFSize:(NSString *)preferedRawPDFSize;

+ (BOOL)layoutShowReceiptDate;
+ (void)setLayoutShowReceiptDate:(BOOL)value;

+ (BOOL)layoutShowReceiptCategory;
+ (void)setLayoutShowReceiptCategory:(BOOL)value;

+ (BOOL)layoutShowReceiptAttachmentMarker;
+ (void)setLayoutShowReceiptAttachmentMarker:(BOOL)value;

+ (void)setPreferredReportLanguage:(NSString *)langugage;
+ (NSString *)preferredReportLanguage;

+ (NSInteger)cameraMaxHeightWidth;
+ (void)setCameraMaxHeightWidth:(NSInteger)cameraMaxHeightWidth;

+ (BOOL)cameraSaveImagesBlackAndWhite;
+ (void)setCameraSaveImagesBlackAndWhite:(BOOL)value;

+ (BOOL)cameraRotateImage;
+ (void)setCameraRotateImage:(BOOL)value;

+ (BOOL)isAutocompleteEnabled;
+ (void)setAutocompleteEnabled:(BOOL)value;

+ (NSString *)pdfFooterString;
+ (void)setPDFFooterString:(NSString *)string;

+ (BOOL)includeCategoricalSummation;
+ (void)setIncludeCategoricalSummation:(BOOL)value;

+ (BOOL)separatePaymantsByCategory;
+ (void)setSeparatePaymantsByCategory:(BOOL)value;

+ (BOOL)omitDefaultPdfTable;
+ (void)setOmitDefaultPdfTable:(BOOL)value;

+ (void)save;

+ (float)MIN_FLOAT;

+ (void)setFromXmlString:(NSString *)xmlString;
+ (NSString *)xmlString;

+ (BOOL)assumeFullPage;
+ (void)setAssumeFullPage:(BOOL)value;

+ (BOOL)autobackupWifiOnly;
+ (void)setAutobackupWifiOnly:(BOOL)value;
    
// Automatic Scan Settigns
+ (BOOL)automaticScansEnabled;
+ (void)setAutomaticScansEnabled:(BOOL)value;
    
+ (BOOL)allowSaveImageForAccuracy;
+ (void)setAllowSaveImageForAccuracy:(BOOL)value;
    
// Privacy Settings
+ (BOOL)analyticsEnabled;
+ (void)setAnalyticsEnabled:(BOOL)value;
    
+ (BOOL)crashTrackingEnabled;
+ (void)setCrashTrackingEnabled:(BOOL)value;
    
+ (BOOL)adPersonalizationEnabled;
+ (void)setAdPersonalizationEnabled:(BOOL)value;

@end
