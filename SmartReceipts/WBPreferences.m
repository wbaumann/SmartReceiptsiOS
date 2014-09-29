//
//  WBPreferences.m
//  SmartReceipts
//
//  Created on 27/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBPreferences.h"
#import <float.h>

#import "WBCurrency.h"
#import "WBDateFormatter.h"

#import "GDataXMLNode.h"

//static NSDecimalNumber* const MIN_FLOAT = ;

static NSString * const STRING_DEFAULT_EMAIL_TO = @"EmailTo";
static NSString * const INT_DEFAULT_TRIP_DURATION = @"TripDuration";
static NSString * const STRING_USERNAME = @"UserName";
static NSString * const BOOL_PREDICT_CATEGORIES = @"PredictCats";
static NSString * const BOOL_MATCH_COMMENT_WITH_CATEGORIES = @"MatchCommentCats";
static NSString * const BOOL_MATCH_NAME_WITH_CATEGORIES = @"MatchNameCats";
static NSString * const BOOL_USE_NATIVE_CAMERA = @"UseNativeCamera"; // UNUSED
static NSString * const BOOL_ACTION_SEND_SHOW_HELP_DIALOG = @"ShowHelpDialog";
static NSString * const BOOL_ONLY_INCLUDE_EXPENSABLE_ITEMS = @"OnlyIncludeExpensable";
static NSString * const BOOL_INCLUDE_TAX_FIELD = @"IncludeTaxField";
static NSString * const BOOL_ENABLE_AUTOCOMPLETE_SUGGESTIONS = @"EnableAutoCompleteSuggestions";
static NSString * const STRING_CURRENCY = @"isocurr";
static NSString * const STRING_DATE_SEPARATOR = @"dateseparator";
static NSString * const FLOAT_MIN_RECEIPT_PRICE = @"MinReceiptPrice";
// static NSString * const INT_VERSION_CODE = @"VersionCode";
static NSString * const BOOL_INCL_CSV_HEADERS = @"IncludeCSVHeaders";
static NSString * const BOOL_DEFAULT_TO_FIRST_TRIP_DATE = @"DefaultToFirstReportDate";
// static NSString * const STRING_LAST_ACTIVITY_TAG = @"LastActivityTag";

// only for iOS
static NSString * const INT_CAMERA_MAX_HEIGHT_WIDTH = @"CameraMaxHeightWidth";

// there is no 100% guaranteed way to figure entry type so we have to hardcode them
typedef enum {
    EntryTypeString = 0,
    EntryTypeInt,
    EntryTypeBool,
    EntryTypeFloat,
} EntryType;

static NSDictionary* getEntryTypes() {
    NSNumber *tString = @(EntryTypeString);
    NSNumber *tInt = @(EntryTypeInt);
    NSNumber *tBool = @(EntryTypeBool);
    NSNumber *tFloat = @(EntryTypeFloat);
    
    return @{
             INT_DEFAULT_TRIP_DURATION: tInt,
             FLOAT_MIN_RECEIPT_PRICE: tFloat,
             STRING_DEFAULT_EMAIL_TO: tString,
             
             BOOL_PREDICT_CATEGORIES: tBool,
             BOOL_USE_NATIVE_CAMERA: tBool,
             BOOL_MATCH_COMMENT_WITH_CATEGORIES: tBool,
             
             BOOL_MATCH_NAME_WITH_CATEGORIES: tBool,
             BOOL_ONLY_INCLUDE_EXPENSABLE_ITEMS: tBool,
             BOOL_ACTION_SEND_SHOW_HELP_DIALOG: tBool,
             
             BOOL_INCLUDE_TAX_FIELD: tBool,
             BOOL_ENABLE_AUTOCOMPLETE_SUGGESTIONS: tBool,
             STRING_USERNAME: tString,
             
             STRING_CURRENCY: tString,
             
             BOOL_INCL_CSV_HEADERS: tBool,
             STRING_DATE_SEPARATOR: tString,
             BOOL_DEFAULT_TO_FIRST_TRIP_DATE: tBool,
             
             INT_CAMERA_MAX_HEIGHT_WIDTH: tInt
             };
}

static NSDictionary* getDefaultValues() {
    // we do it this way because wbcurrency will filter out invalid currency code
    NSString *currencyCode = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode];
    WBCurrency *currency = [WBCurrency currencyForCode:currencyCode];
    currencyCode = [currency code];
    
    NSString *dateSeparator = [[[WBDateFormatter alloc] init] separatorForCurrentLocale];
    
    NSLog(@"default currency: %@",currencyCode);
    NSLog(@"default date separator: %@",dateSeparator);
    
    return @{
             INT_DEFAULT_TRIP_DURATION: @3,
             FLOAT_MIN_RECEIPT_PRICE: [NSDecimalNumber minimumDecimalNumber],
             STRING_DEFAULT_EMAIL_TO: @"",
             
             BOOL_PREDICT_CATEGORIES: @YES,
             BOOL_USE_NATIVE_CAMERA: @NO,
             BOOL_MATCH_COMMENT_WITH_CATEGORIES: @NO,
             
             BOOL_MATCH_NAME_WITH_CATEGORIES: @NO,
             BOOL_ONLY_INCLUDE_EXPENSABLE_ITEMS: @NO,
             BOOL_ACTION_SEND_SHOW_HELP_DIALOG: @YES,
             
             BOOL_INCLUDE_TAX_FIELD: @NO,
             BOOL_ENABLE_AUTOCOMPLETE_SUGGESTIONS: @YES,
             STRING_USERNAME: @"",
             
             STRING_CURRENCY: currencyCode,
             
             BOOL_INCL_CSV_HEADERS: @NO,
             STRING_DATE_SEPARATOR: dateSeparator,
             BOOL_DEFAULT_TO_FIRST_TRIP_DATE: @NO,
             
             INT_CAMERA_MAX_HEIGHT_WIDTH: @1024
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

+(BOOL) predictCategories {
    return [instance() boolForKey:BOOL_PREDICT_CATEGORIES];
}
+(void) setPredictCategories:(BOOL) predictCategories {
    [instance() setBool:predictCategories forKey:BOOL_PREDICT_CATEGORIES];
}

+(BOOL) matchCommentToCategory {
    return [instance() boolForKey:BOOL_MATCH_COMMENT_WITH_CATEGORIES];
}
+(void) setMatchCommentToCategory:(BOOL) matchCommentToCategory {
    [instance() setBool:matchCommentToCategory forKey:BOOL_MATCH_COMMENT_WITH_CATEGORIES];
}

+(BOOL) matchNameToCategory {
    return [instance() boolForKey:BOOL_MATCH_NAME_WITH_CATEGORIES];
}
+(void) setMatchNameToCategory:(BOOL) matchNameToCategory {
    [instance() setBool:matchNameToCategory forKey:BOOL_MATCH_NAME_WITH_CATEGORIES];
}

+(BOOL) onlyIncludeExpensableReceiptsInReports {
    return [instance() boolForKey:BOOL_ONLY_INCLUDE_EXPENSABLE_ITEMS];
}
+(void) setOnlyIncludeExpensableReceiptsInReports:(BOOL) onlyIncludeExpensableReceiptsInReports {
    [instance() setBool:onlyIncludeExpensableReceiptsInReports forKey:BOOL_ONLY_INCLUDE_EXPENSABLE_ITEMS];
}

+(BOOL) includeTaxField {
    return [instance() boolForKey:BOOL_INCLUDE_TAX_FIELD];
}
+(void) setIncludeTaxField:(BOOL) includeTaxField {
    [instance() setBool:includeTaxField forKey:BOOL_INCLUDE_TAX_FIELD];
}

+(NSString*) dateSeparator {
    return [instance() stringForKey:STRING_DATE_SEPARATOR];
}
+(void) setDateSeparator:(NSString*) dateSeparator {
    [instance() setObject:dateSeparator forKey:STRING_DATE_SEPARATOR];
}

+(BOOL) enableAutoCompleteSuggestions {
    return [instance() boolForKey:BOOL_ENABLE_AUTOCOMPLETE_SUGGESTIONS];
}
+(void) setEnableAutoCompleteSuggestions:(BOOL) enableAutoCompleteSuggestions {
    [instance() setBool:enableAutoCompleteSuggestions forKey:BOOL_ENABLE_AUTOCOMPLETE_SUGGESTIONS];
}

+(NSString*) defaultEmailReceipient {
    return [instance() stringForKey:STRING_DEFAULT_EMAIL_TO];
}
+(void) setDefaultEmailReceipient:(NSString*) defaultEmailReceipient {
    [instance() setObject:defaultEmailReceipient forKey:STRING_DEFAULT_EMAIL_TO];
}

+(NSString*) defaultCurrency {
    return [instance() stringForKey:STRING_CURRENCY];
}
+(void) setDefaultCurrency:(NSString*) defaultCurrency {
    [instance() setObject:defaultCurrency forKey:STRING_CURRENCY];
}

+(NSString*) userID {
    return [instance() stringForKey:STRING_USERNAME];
}
+(void) setUserID:(NSString*) userID {
    [instance() setObject:userID forKey:STRING_USERNAME];
}

+(int) defaultTripDuration {
    return (int)[instance() integerForKey:INT_DEFAULT_TRIP_DURATION];
}
+(void) setDefaultTripDuration:(int) defaultTripDuration {
    [instance() setInteger:defaultTripDuration forKey:INT_DEFAULT_TRIP_DURATION];
}

+(NSDecimalNumber*) minimumReceiptPriceToIncludeInReports {
    return [NSDecimalNumber decimalNumberWithString:FLOAT_MIN_RECEIPT_PRICE];
}
+(void) setMinimumReceiptPriceToIncludeInReports:(NSDecimalNumber*) minimumReceiptPriceToIncludeInReports {
    minimumReceiptPriceToIncludeInReports = [NSDecimalNumber decimalNumberWithString:FLOAT_MIN_RECEIPT_PRICE];
}

+(BOOL) defaultToFirstReportDate {
    return [instance() boolForKey:BOOL_DEFAULT_TO_FIRST_TRIP_DATE];
}
+(void) setDefaultToFirstReportDate:(BOOL) defaultToFirstReportDate {
    [instance() setBool:defaultToFirstReportDate forKey:BOOL_DEFAULT_TO_FIRST_TRIP_DATE];
}

+(BOOL) includeCSVHeaders {
    return [instance() boolForKey:BOOL_INCL_CSV_HEADERS];
}
+(void) setIncludeCSVHeaders:(BOOL) includeCSVHeaders {
    [instance() setBool:includeCSVHeaders forKey:BOOL_INCL_CSV_HEADERS];
}

+(int) cameraMaxHeightWidth {
    return (int)[instance() integerForKey:INT_CAMERA_MAX_HEIGHT_WIDTH];
}
+(void) setCameraMaxHeightWidth:(int) cameraMaxHeightWidth {
    [instance() setInteger:cameraMaxHeightWidth forKey:INT_CAMERA_MAX_HEIGHT_WIDTH];
}

+(void) save {
    [instance() synchronize];
}

//+(NSDecimalNumber*) MIN_FLOAT {
//    return MIN_FLOAT;
//}

// for import / export

// sometimes shared prefs on android have doubled roots
+(NSString*) stringWithFixedMultipleXmlRoots:(NSString*) originalXml {
    NSRange range = [originalXml rangeOfString:@"</map>"];
    if(range.location != NSNotFound){
        originalXml = [originalXml substringToIndex:(range.location + range.length)];
    }
    return originalXml;
}

+(void) setFromXmlString:(NSString*) xmlString {
    NSUserDefaults *defaults = instance();
    
    xmlString = [WBPreferences stringWithFixedMultipleXmlRoots:xmlString];
    
    GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc]initWithXMLString:xmlString options:0 error:nil];
    GDataXMLElement *root = [xmlDocument rootElement];
    
    for (GDataXMLElement *e in [root elementsForName:@"string"]) {
        NSString *name = [[e attributeForName:@"name"] stringValue];
        NSString *value = [e stringValue];
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
}

+(NSString*) xmlString {
    [WBPreferences save];
    
    NSUserDefaults *defaults = instance();
    NSDictionary *types = getEntryTypes();
    
    GDataXMLElement *root = [GDataXMLNode elementWithName:@"map"];
    
    for (NSString* key in types) {
        EntryType type = [((NSNumber*)[types objectForKey:key]) intValue];
        
        GDataXMLElement * el = nil;
        switch (type) {
            case EntryTypeString:
                el = [GDataXMLNode elementWithName:@"string"
                                       stringValue:[defaults stringForKey:key]];
                break;
                
            case EntryTypeBool:
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

@end
