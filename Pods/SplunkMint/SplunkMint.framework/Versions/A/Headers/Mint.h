//
//  Mint.h
//  SplunkMint
//
//  Copyright (c) 2016 Splunk. All rights reserved.

#import <Foundation/Foundation.h>
#include <pthread.h>
#import "MintLimitedExtraData.h"
#import "MintEnums.h"
#import "MintUtilities.h"



/**
 *  MintLogException is a helper function that calls the [[Mint sharedInstance] logException:extraData:].
 *  This function logs a handled exception with any optional data.
 *
 *  @param exception The handled exception instance.
 *  @param extradata The extra data to include in the request.
 *
 *  @return void. Nothing to return.
 */
#define MintLogException(exception, extradata) [[Mint sharedInstance] logException:exception extraData:extradata];

/**
 *MINT_METHOD_TRACE_START and MINT_METHOD_TRACE_STOP macro logs a method invocation with class name, method name and elapsed time.
 *If you are not using ARC, use MINT_NONARC_METHOD_TRACE_STOP macro to avoid memory leaks when you stop the trace.
 */
#define MINT_METHOD_TRACE_START \
NSMutableDictionary *mintTraceInfo = [[NSMutableDictionary alloc] init];\
[mintTraceInfo setObject:[NSString stringWithFormat:@"%s", __FUNCTION__] forKey:@"method"];\
[mintTraceInfo setObject:@(getCurrentTimeInNanos()) forKey:@"startTime"];\
[mintTraceInfo setObject:@(pthread_mach_thread_np(pthread_self())) forKey:@"threadID"];\


#define MINT_METHOD_TRACE_STOP \
[mintTraceInfo setObject:@(getCurrentTimeInNanos()) forKey:@"endTime"];\
[[Mint sharedInstance] logMethodTrace:mintTraceInfo];\

#define MINT_NONARC_METHOD_TRACE_STOP \
[mintTraceInfo setObject:@(getCurrentTimeInNanos()) forKey:@"endTime"];\
[[Mint sharedInstance] logMethodTrace:mintTraceInfo];\
[mintTraceInfo release];\
mintTraceInfo = nil;\


/**
 *  Predefined application environments.
 */
extern NSString * const SPLAppEnvRelease;
extern NSString * const SPLAppEnvStaging;
extern NSString * const SPLAppEnvUserAcceptanceTesting;
extern NSString * const SPLAppEnvTesting;
extern NSString * const SPLAppEnvDevelopment;


/**
 *  The **Mint** class is the main class for all appropriate requests.
 */

/**
 *  The **Mint** class.
 */
@interface Mint : NSObject

/**
 *  Returns the singleton **Mint** reference to use in your application. 
 * You should not initialize the **Mint** class yourself because unexpected results may occur.
 *
 *  @return The **Mint** singleton instance reference.
 */
+ (Mint*) sharedInstance;


/**
 *  Indicates whether the plugin is initialized and operating properly.
 */
- (BOOL) isInitialized;

/**
 *  Indicates whether there is an active session. You can close the current session and start a new one as needed.
 */
- (BOOL) isSessionActive;

/**
 * Indicates whether additional logging output should be generated from the SDK.
 * The default is NO.
 *
 *  @param enable YES to generate additional logging.
 */
- (void)enableDebugLog:(BOOL) enable;

/**
 *  A user identifier for the current user, such as a random ID, an email address, or a username.
 */
@property (nonatomic, strong) NSString* userIdentifier;


/**
 *  Sets an application environment. Use a custom string or one of the predefined enviroment constants:
 * <ul>
 * <li>SPLAppEnvRelease</li>
 * <li>SPLAppEnvStaging</li>
 * <li>SPLAppEnvUserAcceptanceTesting</li>
 * <li>SPLAppEnvTesting</li>
 * <li>SPLAppEnvDevelopment</li>
 * </ul>
 *  If not explicitly set, the default is SPLAppEnvRelease.
 */
@property (nonatomic, strong) NSString* applicationEnvironment;

/**
 * Disables the crash reporter.
 *
 */
- (void) disableCrashReporter;

/**
 * Sends all cached requests to the server.
 */
- (void) flush;


#pragma mark *** Initialize Mint SDK ***

/**
 * Initializes the SDK and starts a new session for the 
 * MINT Data Collector environment. This method sends a ping 
 * request and receives remote settings.
 *
 *  @param apiKey The Splunk MINT API key for the mobile app.
 */

- (void) initAndStartSessionWithAPIKey:(NSString*)apiKey;

/**
 * Initializes the SDK and starts a new session the HTTP Event 
 * Collector (HEC) environment to send data over HTTP or 
 * HTTPS directly to Splunk Enterprise. This method validates the URL
 * and sends a ping request. 
 *
 *  @param url The URL of the HEC MINT endpoint. 
 *  @param token The HEC input token.
 */

- (void) initAndStartSessionWithHECUrl:(NSString*)url token:(NSString*)token;

/**
 *  Adds a breadcrumb description to the global breadcrumb list.
 *
 *  @param crumb The breadcrumb description.
 */
- (void) leaveBreadcrumb: (NSString*)crumb;

/**
 *  Clears the global breadcrumb list.
 */
- (void) clearBreadcrumbs;


/**
 *  Starts a new session. If a previous session was initialized less than one minute earlier, this call is ignored. 
 *
 */
- (void) startSession;

/**
 *  Closes the session. All requests and crash reporting will continue to work properly, but the session is no longer logically active.
 *
 */
- (void) closeSession;


/**
 *  Logs a handled exception in your `try/catch` block.
 *
 *  @param exception The **NSException** instance.
 */
- (void) logException: (NSException*)exception;

/**
 *  Logs a handled exception in your `try/catch` block and attaches extra data to the request.
 *
 *  @param exception The **NSException** instance.
 *  @param key       The key for the extra data.
 *  @param value     The value of the extra data.
 */
- (void) logException: (NSException*)exception extraDataKey: (NSString*)key extraDataValue: (NSString*)value;

/**
 *  Logs a handled exception in your `try/catch` block and attaches extra data to the request.
 *
 *  @param exception              The **NSException** instance.
 *  @param extraDataDictionary    A MintLimitedExtraData instance containing extra data.
 */
- (void) logException: (NSException*)exception extraData: (MintLimitedExtraData*)extraDataDictionary;

/**
 *  Disables network monitoring. Call this method before calling 
 * **initAndStartSessionWithAPIKey** or **initAndStartSessionWithHECUrl**.
 */
- (void) disableNetworkMonitoring;

/**
 *  Gets the developer's remote settings as key-value pairs.
 *
 *  @return A dictionary of key-value pairs.
 */
- (NSDictionary*) getDevSettings;

/**
 *  Indicates whether to enable logging. When YES, NSLog console messages
 *  are cached and sent with the exception.
 *
 *  @param enable YES to enable logging.
 */
- (void) enableMintLoggingCache:(BOOL)enable;

/**
 *  Indicates whether to attach device logs to the crash.
 *
 *  @param enable YES to attach device logs.
 */
- (void) enableLogging:(BOOL)enable;

/**
 *  Indicates whether to only send data over a WiFi connection.
 *
 *  @param enable YES to send data only over WiFi.
 */
- (void) enableFlushOnlyOverWiFi:(BOOL)enable;

/**
 *  Sets the maximum number of lines to cache from the console log.
 *
 *  @param linesCount The number of lines.
 */
- (void) setLogging:(NSInteger)linesCount;

/**
 *  Starts a named transaction.
 *
 *  @param transactionName The transaction name.
 *  @returns                The transaction ID
 *
 */
- (NSString*) transactionStart:(NSString*)transactionName;

/**
 *  Starts a named transaction and attaches extra data to the request.
 *
 *  @param transactionName  The transaction name.
 *  @param key              The key for the extra data.
 *  @param value            The value of the extra data.
 *  @returns                The transaction ID
 */
- (NSString*) transactionStart:(NSString*)transactionName extraDataKey: (NSString*)key extraDataValue: (NSString*)value;

/**
 *  Starts a named transaction and attaches extra data to the request.
 *
 *  @param transactionName      The transaction name.
 *  @param extraDataDictionary  A **MintLimitedExtraData** instance containing extra data.
 *  @returns                    The transaction ID
 */
- (NSString*) transactionStart:(NSString*)transactionName extraData: (MintLimitedExtraData*)extraDataDictionary;

/**
 *  Stops a transaction.
 *
 *  @param transactionID The ID of the transaction.
 */
- (void) transactionStop:(NSString*)transactionID;

/**
 *  Stops a transaction and attaches extra data to the request.
 *
 *  @param transactionID    The ID of the transaction.
 *  @param key              The key for the extra data.
 *  @param value            The value of the extra data.
 */
- (void) transactionStop:(NSString*)transactionID extraDataKey: (NSString*)key extraDataValue: (NSString*)value;

/**
 *  Stops a transaction and attaches extra data to the request.
 *
 *  @param transactionID        The ID of the transaction.
 *  @param extraDataDictionary  A **MintLimitedExtraData** instance containing extra data.
 */
- (void) transactionStop:(NSString*)transactionID extraData: (MintLimitedExtraData*)extraDataDictionary;

/**
 *  Cancels a transaction.
 *
 *  @param transactionID   The ID of the transaction.
 *  @param aReason         The reason for cancelling the transaction.
 */
- (void) transactionCancel:(NSString*)transactionID reason:(NSString*)aReason;

/**
 *  Cancels a transaction and attaches extra data to the request.
 *
 *  @param transactionID    The ID of the transaction.
 *  @param aReason          The reason for cancelling the transaction.
 *  @param key              The key for the additional extra data.
 *  @param value            The value of the additional extra data.
 */
- (void) transactionCancel:(NSString*)transactionID reason:(NSString*)aReason extraDataKey: (NSString*)key extraDataValue: (NSString*)value;

/**
 *  Cancels a transaction and attaches extra data to the request.
 *
 *  @param transactionID        The ID of the transaction.
 *  @param aReason              The reason for cancelling the transaction.
 *  @param extraDataDictionary  A **MintLimitedExtraData** instance containing extra data.
 */
- (void) transactionCancel:(NSString*)transactionID reason:(NSString*)aReason extraData: (MintLimitedExtraData*)extraDataDictionary;

/**
 *  Adds a URL to the network monitoring blacklist.
 *
 *  @param url The URL to ignore. This can be a partial URL.
 */
- (void) addURLToBlackList:(NSString*)url;

/**
 *  The URLs blacklisted from network monitoring.
 *
 *  @return A modifiable array that contains the blacklisted URLs.
 */
- (NSMutableArray*) blacklistUrls;


/**
 *  Logs an event.
 *
 *  @param name The name of the event (up to 256 characters).
 */
- (void) logEventWithName: (NSString*)name;

/**
 *  Logs an event with a log level.
 *
 *  @param name      The name of the event (up to 256 characters).
 *  @param logLevel  The **MintLogLevel** enumeration value for the log level.
 */
- (void) logEventWithName:(NSString*)name logLevel:(MintLogLevel)logLevel;

/**
 *  Logs an event with a log level and attaches extra data to the request.
 *
 *  @param name      The name of the event (up to 256 characters).
 *  @param logLevel  The **MintLogLevel** enumeration value for the log level.
 *  @param key       The key for the additional extra data.
 *  @param value     The value of the additional extra data.
 */
- (void) logEventWithName:(NSString *)name logLevel:(MintLogLevel)logLevel extraDataKey: (NSString*)key extraDataValue: (NSString*)value;

/**
 *  Logs an event with a log level and attaches extra data to the request.
 *
 *  @param name         The name of the event (up to 256 characters).
 *  @param logLevel     The **MintLogLevel** enumeration value for the log level.
 *  @param extraDataDictionary    A **MintLimitedExtraData** instance containing extra data.
 */
- (void) logEventWithName:(NSString*)name logLevel:(MintLogLevel)logLevel extraData: (MintLimitedExtraData*)extraDataDictionary;

/**
 * Indicates whether to prevent MINT from saving or sending any data for the user.
 *
 *  @param userOptOut YES to prevent MINT from saving or sending any data.
 */
- (void)enableUserOptOut:(BOOL)userOptOut;

/**
 * Returns the MINT universally unique identifier (UUID), which uniquely identifies a specific user.
 *
 * @returns The UUID of the user.
 */
- (NSString*)getMintUUID;

/**
 * Returns the current session ID.
 *
 * @returns The session ID.
 */
- (NSString*)getSessionID;

/**
 * Logs a specific view as a Splunk data type.
 *
 * @param currentViewName The name of the current view.
 */

- (void)logViewWithCurrentViewName:(NSString*)currentViewName;

/**
 * Logs a specific view as a Splunk data type and attaches extra data to the request.
 *
 * @param currentViewName   The name of the current view.
 * @param key               The key for the extra data.
 * @param value             The value of the extra data.
 */
- (void)logViewWithCurrentViewName:(NSString*)currentViewName extraDataKey: (NSString*)key extraDataValue: (NSString*)value;

/**
 * Logs a specific view as a Splunk data type and attaches extra data to the request.
 *
 * @param currentViewName       The name of the current view.
 * @param extraDataDictionary   A **MintLimitedExtraData** instance containing extra data.
 */
- (void)logViewWithCurrentViewName:(NSString*)currentViewName extraData: (MintLimitedExtraData*)extraDataDictionary;

/**
 *  Configures the session interval.
 *
 *  @param intervalInSeconds The time interval for the session, in seconds.
 */
- (void)setSessionInterval:(NSInteger)intervalInSeconds;

/**
 * Indicates whether the SDK has been initialized to send data over HTTP (or HTTPS) 
 * directly to Splunk Enterprise using the HTTP Event Collector. 
 */
- (BOOL) isHTTPEventCollectorEnabled;

/**
 * Sends the log entry to the console window, and caches a request to send to the server.
 *
 * @param logLevel  The **MintLogLevel** enumeration value for the log level.
 * @param message   The message for the log level.
 */
void MintLog(MintLogLevel logLevel, NSString* message, ...) NS_FORMAT_FUNCTION(2,3);

/**
 *  Adds extra data to the global extra data collection as a key-value pair.
 *
 *  @param value    The extra data value.
 *  @param key      The extra data key.
 */
- (void)addExtraData:(NSString*)value forKey:(NSString *)key;

/**
 *  Adds extra data to the global extra data collection as a dictionary.
 *
 *  @param extraDataDictionary A **MintLimitedExtraData** instance containing extra data.
 */
- (void)addExtraData:(MintLimitedExtraData*)extraDataDictionary;

 /**
 * Gets the extra data that corresponds to a given key.
 *
 * @param key   The key.
 * @return      The value.
 */
- (NSString*)extraDataForKey:(NSString *)key;

/**
 * Remove an entry from the global extra data collection for a given key.
 *
 * @param key The key of the extra data entry.
 */
- (void)removeExtraDataForKey:(NSString*)key;

/**
 *  Clears the global extra data collection.
 */
- (void)removeAllExtraData;

/**
 * Gets the global extra data collection.
 */
- (NSDictionary*)extraData;

/**
 * Starts a timer. 
 * @param timerName The name of the timer. 
 * @return The timer ID.
 */
- (NSString*)startTimerWithName:(NSString*)timerName;

/**
 * Stops a timer.
 * @param timerId The timer ID.
 */
- (void)stopTimerWithId:(NSString*)timerId;

/**
 *  Used internally by the SDK to log trace information for methods.
 * @param traceInfo The trace information.
 */
- (void)logMethodTrace:(NSDictionary*)traceInfo;

/**
 * Used internally by the SDK to log memory information when memory warnings
 * are received. 
 * @param className The name of the class that received a memory warning.
 */
-(void)logMemoryWarningWithClassName:(NSString*)className;

@end
