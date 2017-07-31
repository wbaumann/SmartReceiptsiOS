//
//  WBPreferences.m
//  SmartReceipts
//
//  Created on 27/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBPreferences.h"

#import "WBDateFormatter.h"

#import "GDataXMLNode.h"
#import "Constants.h"
#import "Database.h"
#import "Database+Purchases.h"

static const float MIN_FLOAT = -FLT_MAX;

static NSString * const STRING_DEFAULT_EMAIL_TO = @"EmailTo";
static NSString * const STRING_DEFAULT_EMAIL_CC = @"EmailCC";
static NSString * const STRING_DEFAULT_EMAIL_BCC = @"EmailBCC";
static NSString * const STRING_DEFAULT_EMAIL_SUBJECT = @"EmailSubject";
static NSString * const INT_DEFAULT_TRIP_DURATION = @"TripDuration";
static NSString * const BOOL_ALLOW_DATA_OUTSIDE_TRIP_BOUNDS = @"AllowDataOutsideTripBounds";
static NSString * const BOOL_AUTOCOMPLETE_ENABLED = @"IsAutocompleteEnabled";
static NSString * const STRING_USERNAME = @"UserName";
static NSString * const STRING_FULLNAME = @"FullName";
static NSString * const BOOL_PREDICT_CATEGORIES = @"PredictCats";
static NSString * const BOOL_MATCH_COMMENT_WITH_CATEGORIES = @"MatchCommentCats";
static NSString * const BOOL_MATCH_NAME_WITH_CATEGORIES = @"MatchNameCats";
static NSString * const BOOL_USE_NATIVE_CAMERA = @"UseNativeCamera"; // UNUSED
static NSString * const BOOL_ACTION_SEND_SHOW_HELP_DIALOG = @"ShowHelpDialog";
static NSString * const BOOL_ONLY_INCLUDE_REIMBURSABLE_ITEMS = @"OnlyIncludeExpensable";
static NSString * const BOOL_EXPENSABLE_DEFAULT = @"ExpensableDefault";
static NSString * const BOOL_INCLUDE_TAX_FIELD = @"IncludeTaxField";
static NSString * const STRING_CURRENCY = @"isocurr";
static NSString * const STRING_DATE_SEPARATOR = @"dateseparator";
static NSString * const FLOAT_MIN_RECEIPT_PRICE = @"MinReceiptPrice";
// static NSString * const INT_VERSION_CODE = @"VersionCode";
static NSString * const BOOL_INCL_CSV_HEADERS = @"IncludeCSVHeaders";
static NSString * const BOOL_DEFAULT_TO_FIRST_TRIP_DATE = @"DefaultToFirstReportDate";
// static NSString * const STRING_LAST_ACTIVITY_TAG = @"LastActivityTag";

// only for iOS
static NSString * const INT_CAMERA_MAX_HEIGHT_WIDTH = @"CameraMaxHeightWidth";
static NSString * const BOOL_CAMERA_BLACK_AND_WHITE = @"SaveBW";
static NSString * const BOOL_CAMERA_ROTATE_IMAGE = @"Camera_Rotate";

//distance settings
static NSString *const BOOL_INCLUDE_MILEAGE_TOTAL_IN_REPORT = @"MileageTotalInReport";
static NSString *const FLOAT_DEFAULT_MILEAGE_RATE = @"MileageRate";
static NSString *const BOOL_PRINT_MILEAGE_TABLE = @"MileagePrintTable";
static NSString *const BOOL_DAILY_DISTANCE_REPORT = @"MileageAddToPDF";

static NSString *const BOOL_USE_PAYMENT_METHODS = @"UsePaymentMethods";

static NSString *const BOOL_TRACK_COST_CENTER = @"trackcostcenter";

static NSString *const FLOAT_DEFAULT_TAX_PERCENTAGE = @"TaxPercentage";
static NSString *const BOOL_ENTERED_PRICE_PRE_TAX = @"PreTax";
static NSString *const BOOL_ASSUME_FULL_PAGE = @"AssumeFullPage";
static NSString *const BOOL_SHOW_RECEIPT_ID = @"ShowReceiptID";
static NSString *const BOOL_PHOTO_PRINT_ID_INSTEAD_OF_INDEX = @"PrintByIDPhotoKey";
static NSString *const BOOL_PRINT_COMMENT_BY_PHOTO = @"PrintCommentByPhoto";
static NSString *const BOOL_PRINT_RECEIPT_TABLE_LANDSCAPE = @"ReceiptsTableLandscape";
static NSString *const BOOL_LAYOUT_SHOW_RECEIPT_DATE = @"LayoutIncludeReceiptDate";
static NSString *const BOOL_LAYOUT_SHOW_RECEIPT_CATEGORY = @"LayoutIncludeReceiptCategory";
static NSString *const BOOL_LAYOUT_SHOW_RECEIPT_ATTACHMENT_MARKER = @"LayoutIncludeReceiptPicture";

static NSString *const PDF_FOOTER_STRING = @"PdfFooterString";

static NSArray *__emailFields;

// there is no 100% guaranteed way to figure entry type so we have to hardcode them
typedef NS_ENUM(short, EntryType){
    EntryTypeString = 0,
    EntryTypeInt,
    EntryTypeBool,
    EntryTypeFloat,
    EntryTypeDouble,
};

static NSDictionary *getEntryTypes() {
    NSNumber *tString = @(EntryTypeString);
    NSNumber *tInt = @(EntryTypeInt);
    NSNumber *tBool = @(EntryTypeBool);
    NSNumber *tFloat = @(EntryTypeFloat);
    NSNumber *tDouble = @(EntryTypeFloat);

    return @{
            INT_DEFAULT_TRIP_DURATION : tInt,
            BOOL_AUTOCOMPLETE_ENABLED : tBool,
            BOOL_ALLOW_DATA_OUTSIDE_TRIP_BOUNDS : tBool,
            FLOAT_MIN_RECEIPT_PRICE : tFloat,

            STRING_DEFAULT_EMAIL_TO : tString,
            STRING_DEFAULT_EMAIL_CC : tString,
            STRING_DEFAULT_EMAIL_BCC : tString,
            STRING_DEFAULT_EMAIL_SUBJECT : tString,

            BOOL_PREDICT_CATEGORIES : tBool,
            BOOL_USE_NATIVE_CAMERA : tBool,
            BOOL_MATCH_COMMENT_WITH_CATEGORIES : tBool,

            BOOL_MATCH_NAME_WITH_CATEGORIES : tBool,
            BOOL_ONLY_INCLUDE_REIMBURSABLE_ITEMS : tBool,
            BOOL_EXPENSABLE_DEFAULT : tBool,
            BOOL_ACTION_SEND_SHOW_HELP_DIALOG : tBool,

            BOOL_INCLUDE_TAX_FIELD : tBool,
            STRING_USERNAME : tString,
            STRING_FULLNAME : tString,

            STRING_CURRENCY : tString,

            BOOL_INCL_CSV_HEADERS : tBool,
            STRING_DATE_SEPARATOR : tString,
            BOOL_DEFAULT_TO_FIRST_TRIP_DATE : tBool,

            INT_CAMERA_MAX_HEIGHT_WIDTH : tInt,
            BOOL_CAMERA_BLACK_AND_WHITE : tBool,
            BOOL_CAMERA_ROTATE_IMAGE : tBool,

            BOOL_INCLUDE_MILEAGE_TOTAL_IN_REPORT: tBool,
            FLOAT_DEFAULT_MILEAGE_RATE: tDouble,
            BOOL_PRINT_MILEAGE_TABLE: tBool,
            BOOL_DAILY_DISTANCE_REPORT: tBool,

            BOOL_USE_PAYMENT_METHODS: tBool,

            BOOL_TRACK_COST_CENTER : tBool,

            FLOAT_DEFAULT_TAX_PERCENTAGE: tFloat,
            BOOL_ENTERED_PRICE_PRE_TAX: tBool,
            BOOL_ASSUME_FULL_PAGE: tBool,

            BOOL_SHOW_RECEIPT_ID: tBool,

            BOOL_PHOTO_PRINT_ID_INSTEAD_OF_INDEX: tBool,
            BOOL_PRINT_COMMENT_BY_PHOTO: tBool,
            BOOL_PRINT_RECEIPT_TABLE_LANDSCAPE: tBool,
            BOOL_LAYOUT_SHOW_RECEIPT_DATE: tBool,
            BOOL_LAYOUT_SHOW_RECEIPT_CATEGORY: tBool,
            BOOL_LAYOUT_SHOW_RECEIPT_ATTACHMENT_MARKER: tBool,
            
            PDF_FOOTER_STRING: tString,
    };
}

static NSDictionary *getDefaultValues() {
    // we do it this way because Currency will filter out invalid currency code
    NSString *currencyCode = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode];
    Currency *currency = [Currency currencyForCode:currencyCode];
    currencyCode = [currency code];

    NSString *dateSeparator = [[[WBDateFormatter alloc] init] separatorForCurrentLocale];
    
    // This macro is not supported here
    //LOGGER_DEBUG
    [Logger debug:[NSString stringWithFormat:@"default currency: %@", currencyCode] file:[NSString stringWithUTF8String:__FILE__] function:@"" line:0];
    [Logger debug:[NSString stringWithFormat:@"default date separator: %@", dateSeparator] file:[NSString stringWithUTF8String:__FILE__] function:@"" line:0];

    return @{
            INT_DEFAULT_TRIP_DURATION : @3,
            BOOL_AUTOCOMPLETE_ENABLED : @(YES),
            BOOL_ALLOW_DATA_OUTSIDE_TRIP_BOUNDS : @(YES),

            FLOAT_MIN_RECEIPT_PRICE : @(MIN_FLOAT),
            STRING_DEFAULT_EMAIL_TO : @"",
            STRING_DEFAULT_EMAIL_CC : @"",
            STRING_DEFAULT_EMAIL_BCC : @"",
            STRING_DEFAULT_EMAIL_SUBJECT : NSLocalizedString(@"SmartReceipts - %REPORT_NAME%", nil),
            PDF_FOOTER_STRING : NSLocalizedString(@"pdf.report.default.footer.text", nil),

            BOOL_PREDICT_CATEGORIES : @YES,
            BOOL_USE_NATIVE_CAMERA : @NO,
            BOOL_MATCH_COMMENT_WITH_CATEGORIES : @NO,

            BOOL_MATCH_NAME_WITH_CATEGORIES : @NO,
            BOOL_ONLY_INCLUDE_REIMBURSABLE_ITEMS : @NO,
            BOOL_EXPENSABLE_DEFAULT : @YES,
            BOOL_ACTION_SEND_SHOW_HELP_DIALOG : @YES,

            BOOL_INCLUDE_TAX_FIELD : @NO,
            STRING_USERNAME : @"",
            STRING_FULLNAME : @"",

            STRING_CURRENCY : currencyCode,

            BOOL_INCL_CSV_HEADERS : @NO,
            STRING_DATE_SEPARATOR : dateSeparator,
            BOOL_DEFAULT_TO_FIRST_TRIP_DATE : @NO,

            INT_CAMERA_MAX_HEIGHT_WIDTH : @1024,
            BOOL_CAMERA_BLACK_AND_WHITE : @NO,
            BOOL_CAMERA_ROTATE_IMAGE : @YES,

            BOOL_INCLUDE_MILEAGE_TOTAL_IN_REPORT: @NO,
            FLOAT_DEFAULT_MILEAGE_RATE: @(0),
            BOOL_PRINT_MILEAGE_TABLE: @YES,
            BOOL_DAILY_DISTANCE_REPORT: @NO,

            BOOL_TRACK_COST_CENTER : @NO,

            BOOL_ENTERED_PRICE_PRE_TAX: @YES,
            BOOL_ASSUME_FULL_PAGE: @NO,

            BOOL_SHOW_RECEIPT_ID: @NO,

            BOOL_PHOTO_PRINT_ID_INSTEAD_OF_INDEX: @NO,
            BOOL_PRINT_COMMENT_BY_PHOTO: @NO,
            BOOL_PRINT_RECEIPT_TABLE_LANDSCAPE: @NO,
            BOOL_LAYOUT_SHOW_RECEIPT_DATE: @YES,
            BOOL_LAYOUT_SHOW_RECEIPT_CATEGORY: @NO,
            BOOL_LAYOUT_SHOW_RECEIPT_ATTACHMENT_MARKER: @NO,
    };
}

static NSUserDefaults* _sharedInstance = nil;

static NSUserDefaults* instance() {
    if (!_sharedInstance) {
        @synchronized([WBPreferences class]){
            if (!_sharedInstance) {
                _sharedInstance = [NSUserDefaults standardUserDefaults];
                [_sharedInstance registerDefaults:getDefaultValues()];
            }
        }
    }
    return _sharedInstance;
}

@implementation WBPreferences

+ (void)initialize {
    [super initialize];

    __emailFields = @[STRING_DEFAULT_EMAIL_TO, STRING_DEFAULT_EMAIL_CC, STRING_DEFAULT_EMAIL_BCC];
}


+ (BOOL) predictCategories {
    return [instance() boolForKey:BOOL_PREDICT_CATEGORIES];
}

+ (void) setPredictCategories:(BOOL) predictCategories {
    [instance() setBool:predictCategories forKey:BOOL_PREDICT_CATEGORIES];
}

+ (BOOL) matchCommentToCategory {
    return [instance() boolForKey:BOOL_MATCH_COMMENT_WITH_CATEGORIES];
}

+ (void) setMatchCommentToCategory:(BOOL) matchCommentToCategory {
    [instance() setBool:matchCommentToCategory forKey:BOOL_MATCH_COMMENT_WITH_CATEGORIES];
}

+ (BOOL) matchNameToCategory {
    return [instance() boolForKey:BOOL_MATCH_NAME_WITH_CATEGORIES];
}
    
+ (void) setMatchNameToCategory:(BOOL) matchNameToCategory {
    [instance() setBool:matchNameToCategory forKey:BOOL_MATCH_NAME_WITH_CATEGORIES];
}

+ (BOOL) onlyIncludeReimbursableReceiptsInReports {
    return [instance() boolForKey:BOOL_ONLY_INCLUDE_REIMBURSABLE_ITEMS];
}
    
+ (void) setOnlyIncludeReimbursableReceiptsInReports:(BOOL) onlyIncludeReimbursableReceiptsInReports {
    [instance() setBool:onlyIncludeReimbursableReceiptsInReports forKey:BOOL_ONLY_INCLUDE_REIMBURSABLE_ITEMS];
}

+ (BOOL)expensableDefault {
    return [instance() boolForKey:BOOL_EXPENSABLE_DEFAULT];
}

+ (void)setExpensableDefault:(BOOL)expensableDefault {
    [instance() setBool:expensableDefault forKey:BOOL_EXPENSABLE_DEFAULT];
}

+ (BOOL) includeTaxField {
    return [instance() boolForKey:BOOL_INCLUDE_TAX_FIELD];
}

+ (void) setIncludeTaxField:(BOOL) includeTaxField {
    [instance() setBool:includeTaxField forKey:BOOL_INCLUDE_TAX_FIELD];
}

+ (NSString*) dateSeparator {
    return [instance() stringForKey:STRING_DATE_SEPARATOR];
}
    
+ (void) setDateSeparator:(NSString*) dateSeparator {
    [instance() setObject:dateSeparator forKey:STRING_DATE_SEPARATOR];
}

+ (NSString *)defaultEmailRecipient {
    return [instance() stringForKey:STRING_DEFAULT_EMAIL_TO];
}

+ (void)setDefaultEmailRecipient:(NSString *)defaultEmailReceipient {
    [instance() setObject:defaultEmailReceipient forKey:STRING_DEFAULT_EMAIL_TO];
}

+ (NSString *)defaultEmailCC {
    return [instance() stringForKey:STRING_DEFAULT_EMAIL_CC];
}

+ (void)setDefaultEmailCC:(NSString *)defaultEmailReceipient {
    [instance() setObject:defaultEmailReceipient forKey:STRING_DEFAULT_EMAIL_CC];
}

+ (NSString *)defaultEmailBCC {
    return [instance() stringForKey:STRING_DEFAULT_EMAIL_BCC];
}

+ (void)setDefaultEmailBCC:(NSString *)defaultEmailReceipient {
    [instance() setObject:defaultEmailReceipient forKey:STRING_DEFAULT_EMAIL_BCC];
}

+ (NSString *)defaultEmailSubject {
    return [instance() stringForKey:STRING_DEFAULT_EMAIL_SUBJECT];
}

+ (void)setDefaultEmailSubject:(NSString *)value {
    [instance() setObject:value forKey:STRING_DEFAULT_EMAIL_SUBJECT];
}

+ (NSString *)pdfFooterString {
    if (![Database sharedInstance].hasValidSubscription) {
        return NSLocalizedString(@"pdf.report.default.footer.text", nil);
    }
    
    return [instance() objectForKey:PDF_FOOTER_STRING];
}

+ (void)setPDFFooterString:(NSString *)string {
    [instance() setObject:string forKey:PDF_FOOTER_STRING];
}

+ (NSString*) defaultCurrency {
    return [instance() stringForKey:STRING_CURRENCY];
}

+ (void) setDefaultCurrency:(NSString*) defaultCurrency {
    [instance() setObject:defaultCurrency forKey:STRING_CURRENCY];
}

+ (NSString*) userID {
    return [instance() stringForKey:STRING_USERNAME];
}

+ (void) setUserID:(NSString*) userID {
    [instance() setObject:userID forKey:STRING_USERNAME];
}

+ (NSString*) fullName {
    return [instance() stringForKey:STRING_FULLNAME];
}

+ (void) setFullName:(NSString*) fullName {
    [instance() setObject:fullName forKey:STRING_FULLNAME];
}

+ (int) defaultTripDuration {
    return (int)[instance() integerForKey:INT_DEFAULT_TRIP_DURATION];
}

+ (void) setDefaultTripDuration:(int) defaultTripDuration {
    [instance() setInteger:defaultTripDuration forKey:INT_DEFAULT_TRIP_DURATION];
}

+ (float) minimumReceiptPriceToIncludeInReports {
    return [instance() floatForKey:FLOAT_MIN_RECEIPT_PRICE];
}

+ (void) setMinimumReceiptPriceToIncludeInReports:(float) minimumReceiptPriceToIncludeInReports {
    [instance() setFloat:minimumReceiptPriceToIncludeInReports forKey:FLOAT_MIN_RECEIPT_PRICE];
}

+ (float) MIN_FLOAT {
    return MIN_FLOAT;
}

+ (BOOL) defaultToFirstReportDate {
    return [instance() boolForKey:BOOL_DEFAULT_TO_FIRST_TRIP_DATE];
}

+ (void) setDefaultToFirstReportDate:(BOOL) defaultToFirstReportDate {
    [instance() setBool:defaultToFirstReportDate forKey:BOOL_DEFAULT_TO_FIRST_TRIP_DATE];
}

+ (BOOL) includeCSVHeaders {
    return [instance() boolForKey:BOOL_INCL_CSV_HEADERS];
}

+ (void) setIncludeCSVHeaders:(BOOL) includeCSVHeaders {
    [instance() setBool:includeCSVHeaders forKey:BOOL_INCL_CSV_HEADERS];
}

+ (BOOL)isTheDistancePriceBeIncludedInReports {
    return [instance() boolForKey:BOOL_INCLUDE_MILEAGE_TOTAL_IN_REPORT];
}

+ (void)setTheDistancePriceBeIncludedInReports:(BOOL)value {
    [instance() setBool:value forKey:BOOL_INCLUDE_MILEAGE_TOTAL_IN_REPORT];
}

+ (double)distanceRateDefaultValue {
    return [instance() doubleForKey:FLOAT_DEFAULT_MILEAGE_RATE];
}

+ (void)setDistanceRateDefaultValue:(double)value {
    [instance() setDouble:value forKey:FLOAT_DEFAULT_MILEAGE_RATE];
}

+ (float)defaultTaxPercentage {
    return [instance() floatForKey:FLOAT_DEFAULT_TAX_PERCENTAGE];
}

+ (void)setDefaultTaxPercentage:(float)value {
    [instance() setFloat:value forKey:FLOAT_DEFAULT_TAX_PERCENTAGE];
}

+ (BOOL)enteredPricePreTax {
    return [instance() boolForKey:BOOL_ENTERED_PRICE_PRE_TAX];
}

+ (void)setEnteredPricePreTax:(BOOL)value {
    [instance() setBool:value forKey:BOOL_ENTERED_PRICE_PRE_TAX];
}

+ (BOOL)printDistanceTable {
    return [instance() boolForKey:BOOL_PRINT_MILEAGE_TABLE];
}

+ (void)setPrintDistanceTable:(BOOL)value {
    [instance() setBool:value forKey:BOOL_PRINT_MILEAGE_TABLE];
}

+ (BOOL)printDailyDistanceValues {
    return [instance() boolForKey:BOOL_DAILY_DISTANCE_REPORT];
}

+ (void)setPrintDailyDistanceValues:(BOOL)value {
    [instance() setBool:value forKey:BOOL_DAILY_DISTANCE_REPORT];
}

+ (BOOL)usePaymentMethods {
    return [instance() boolForKey:BOOL_USE_PAYMENT_METHODS];
}

+ (void)setUsePaymentMethods:(BOOL)value {
    [instance() setBool:value forKey:BOOL_USE_PAYMENT_METHODS];
}

+ (BOOL)trackCostCenter {
    return [instance() boolForKey:BOOL_TRACK_COST_CENTER];
}

+ (void)setTrackCostCenter:(BOOL)value{
    [instance() setBool:value forKey:BOOL_TRACK_COST_CENTER];
}

+ (BOOL)showReceiptID {
    return [instance() boolForKey:BOOL_SHOW_RECEIPT_ID];
}

+ (void)setShowReceiptID:(BOOL)value {
    [instance() setBool:value forKey:BOOL_SHOW_RECEIPT_ID];
}

+ (BOOL)printReceiptIDByPhoto {
    return [instance() boolForKey:BOOL_PHOTO_PRINT_ID_INSTEAD_OF_INDEX];
}

+ (void)setPrintReceiptIDByPhoto:(BOOL)value {
    [instance() setBool:value forKey:BOOL_PHOTO_PRINT_ID_INSTEAD_OF_INDEX];
}

+ (BOOL)printCommentByPhoto {
    return [instance() boolForKey:BOOL_PRINT_COMMENT_BY_PHOTO];
}

+ (void)setPrintCommentByPhoto:(BOOL)value {
    [instance() setBool:value forKey:BOOL_PRINT_COMMENT_BY_PHOTO];
}

+ (BOOL)printReceiptTableLandscape {
    return [instance() boolForKey:BOOL_PRINT_RECEIPT_TABLE_LANDSCAPE];
}

+ (void)setPrintReceiptTableLandscape:(BOOL)value {
    [instance() setBool:value forKey:BOOL_PRINT_RECEIPT_TABLE_LANDSCAPE];
}

+ (BOOL)layoutShowReceiptDate {
    return [instance() boolForKey:BOOL_LAYOUT_SHOW_RECEIPT_DATE];
}

+ (void)setLayoutShowReceiptDate:(BOOL)value {
    [instance() setBool:value forKey:BOOL_LAYOUT_SHOW_RECEIPT_DATE];
}

+ (BOOL)layoutShowReceiptCategory{
    return [instance() boolForKey:BOOL_LAYOUT_SHOW_RECEIPT_CATEGORY];
}

+ (void)setLayoutShowReceiptCategory:(BOOL)value{
    [instance() setBool:value forKey:BOOL_LAYOUT_SHOW_RECEIPT_CATEGORY];
}

+ (BOOL)layoutShowReceiptAttachmentMarker {
    return [instance() boolForKey:BOOL_LAYOUT_SHOW_RECEIPT_ATTACHMENT_MARKER];
}

+ (void)setLayoutShowReceiptAttachmentMarker:(BOOL)value {
    [instance() setBool:value forKey:BOOL_LAYOUT_SHOW_RECEIPT_ATTACHMENT_MARKER];
}


+ (NSInteger)cameraMaxHeightWidth {
    return [instance() integerForKey:INT_CAMERA_MAX_HEIGHT_WIDTH];
}

+ (void)setCameraMaxHeightWidth:(NSInteger)cameraMaxHeightWidth {
    [instance() setInteger:cameraMaxHeightWidth forKey:INT_CAMERA_MAX_HEIGHT_WIDTH];
}

+ (BOOL)cameraSaveImagesBlackAndWhite{
    return [instance() boolForKey:BOOL_CAMERA_BLACK_AND_WHITE];
}

+ (void)setCameraSaveImagesBlackAndWhite:(BOOL)value{
    [instance() setBool:value forKey:BOOL_CAMERA_BLACK_AND_WHITE];
}

+ (BOOL)cameraRotateImage {
    return [instance() boolForKey:BOOL_CAMERA_ROTATE_IMAGE];
}

+ (void)setCameraRotateImage:(BOOL)value{
    [instance() setBool:value forKey:BOOL_CAMERA_ROTATE_IMAGE];
}

+ (BOOL)isAutocompleteEnabled {
    return [instance() boolForKey:BOOL_AUTOCOMPLETE_ENABLED];
}

+ (void)setAutocompleteEnabled:(BOOL)value{
    [instance() setBool:value forKey:BOOL_AUTOCOMPLETE_ENABLED];
}

+ (BOOL)allowDataEntryOutsideTripBounds {
    return [instance() boolForKey:BOOL_ALLOW_DATA_OUTSIDE_TRIP_BOUNDS];
}

+ (void)setAllowDataEntryOutsideTripBounds:(BOOL)value{
    [instance() setBool:value forKey:BOOL_ALLOW_DATA_OUTSIDE_TRIP_BOUNDS];
}

+ (void) save {
    [instance() synchronize];
}

//+ (NSDecimalNumber*) MIN_FLOAT {
//    return MIN_FLOAT;
//}

// for import / export

// sometimes shared prefs on android have doubled roots
+ (NSString*) stringWithFixedMultipleXmlRoots:(NSString*) originalXml {
    NSRange range = [originalXml rangeOfString:@"</map>"];
    if(range.location != NSNotFound){
        originalXml = [originalXml substringToIndex:(range.location + range.length)];
    }
    return originalXml;
}

+ (void) setFromXmlString:(NSString*) xmlString {
    NSUserDefaults *defaults = instance();
    
    xmlString = [WBPreferences stringWithFixedMultipleXmlRoots:xmlString];
    
    GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc]initWithXMLString:xmlString options:0 error:nil];
    GDataXMLElement *root = [xmlDocument rootElement];
    
    for (GDataXMLElement *e in [root elementsForName:@"string"]) {
        NSString *name = [[e attributeForName:@"name"] stringValue];
        NSString *value = [e stringValue];
        if ([__emailFields containsObject:name]) {
            value = [value stringByReplacingOccurrencesOfString:@";" withString:@","];
        }
        [defaults setObject:value forKey:name];
    }
    
    for (GDataXMLElement *e in [root elementsForName:@"boolean"]) {
        NSString *name = [[e attributeForName:@"name"] stringValue];
        NSString *value = [[e attributeForName:@"value"] stringValue];
        BOOL val = [value caseInsensitiveCompare:@"true"] == NSOrderedSame;
        [defaults setObject:[NSNumber numberWithBool:val] forKey:name];
    }
    
    for (GDataXMLElement *e in [root elementsForName:@"int"]) {
        NSString *name = [[e attributeForName:@"name"] stringValue];
        NSString *value = [[e attributeForName:@"value"] stringValue];
        [defaults setObject:[NSNumber numberWithInt:[value intValue]] forKey:name];
    }
    
    for (GDataXMLElement *e in [root elementsForName:@"float"]) {
        NSString *name = [[e attributeForName:@"name"] stringValue];
        NSString *value = [[e attributeForName:@"value"] stringValue];
        [defaults setObject:[NSNumber numberWithInt:[value floatValue]] forKey:name];
    }
    
    [WBPreferences save];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SmartReceiptsPreferencesImportedNotification object:nil];
    });
}

+ (NSString*) xmlString {
    [WBPreferences save];
    
    NSUserDefaults *defaults = instance();
    NSDictionary *types = getEntryTypes();
    
    GDataXMLElement *root = [GDataXMLNode elementWithName:@"map"];
    
    for (NSString* key in types) {
        EntryType type = [((NSNumber*)[types objectForKey:key]) intValue];
        
        GDataXMLElement * el = nil;
        switch (type) {
            case EntryTypeString: {
                NSString *value = [defaults stringForKey:key];
                if ([__emailFields containsObject:key]) {
                    value = [value stringByReplacingOccurrencesOfString:@"," withString:@";"];
                }
                el = [GDataXMLNode elementWithName:@"string"
                                       stringValue:value];
            }
                break;
                
            case EntryTypeBool:
                el = [GDataXMLNode elementWithName:@"boolean"];
                break;

            case EntryTypeDouble:
                el = [GDataXMLNode elementWithName:@"boolean"];
                break;

            case EntryTypeInt:
                el = [GDataXMLNode elementWithName:@"int"];
                break;
                
            case EntryTypeFloat:
                el = [GDataXMLNode elementWithName:@"float"];
                break;
                
            default:
                break;
        }
        
        if (type != EntryTypeString) {
            NSString *val = [defaults stringForKey:key];
            if (type == EntryTypeBool) {
                val = [defaults boolForKey:key] ? @"true" : @"false";
            }
            [el addAttribute:[GDataXMLNode attributeWithName:@"value"
                                                 stringValue:val]];
        }
        
        if (el) {
            [el addAttribute:[GDataXMLNode attributeWithName:@"name"
                                                 stringValue:key]];
            [root addChild:el];
        }
    }
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:root];
    return [[NSString alloc] initWithData:document.XMLData encoding:NSUTF8StringEncoding];
}

+ (BOOL)assumeFullPage {
    return [instance() boolForKey:BOOL_ASSUME_FULL_PAGE];
}

+ (void)setAssumeFullPage:(BOOL)value {
    [instance() setBool:value forKey:BOOL_ASSUME_FULL_PAGE];
}

@end
