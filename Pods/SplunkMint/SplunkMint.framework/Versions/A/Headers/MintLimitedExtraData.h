//
//  MintLimitedExtraData.h
//  SplunkMint
//
//  Copyright (c) 2016 Splunk. All rights reserved.

#import <Foundation/Foundation.h>

/**
 *  The **MintLimitedExtraData** class contains a list of extra data
 *  key-value pairs to attach to requests.
 */

@interface MintLimitedExtraData : NSObject

/**
 *  Adds extra data as a key-value pair.
 *
 *  @param value The value.
 *  @param key   The key.
 */
- (void)setValue:(NSString*)value forKey:(NSString *)key;

/**
 * Gets the value that corresponds to a given key.
 * @param key The key.
 * @return The value.
 */
- (NSString*)valueForKey:(NSString *)key;

/**
 * Removes data for a given key.
 * @param key The key.
 */ 
 - (void)removeValueForKey:(NSString*)key;

/**
 *  Removes all extra data from the extra data list.
 */
 - (void)removeAllValues;

/**
 * Gets the extra data list.
 */
 - (NSDictionary*)extraDataDictionary;

@end
