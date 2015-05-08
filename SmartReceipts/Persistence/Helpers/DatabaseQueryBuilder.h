//
//  DatabaseQueryBuilder.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseQueryBuilder : NSObject

@property (nonatomic, copy) NSString *sumColumn;

+ (DatabaseQueryBuilder *)insertStatementForTable:(NSString *)tableName;
+ (DatabaseQueryBuilder *)deleteStatementForTable:(NSString *)tableName;
+ (DatabaseQueryBuilder *)updateStatementForTable:(NSString *)tableName;
+ (DatabaseQueryBuilder *)sumStatementForTable:(NSString *)tableName;

- (void)addParam:(NSString *)paramName value:(NSObject *)paramValue;
- (void)addParam:(NSString *)paramName value:(NSObject *)paramValue fallback:(NSObject *)valueFallback;
- (void)where:(NSString *)paramName value:(NSObject *)paramValue;

- (NSString *)buildStatement;
- (NSDictionary *)parameters;

@end
