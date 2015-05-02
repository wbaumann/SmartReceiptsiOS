//
//  DatabaseQueryBuilder.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseQueryBuilder : NSObject

+ (DatabaseQueryBuilder *)insertStatementForTable:(NSString *)tableName;

- (void)addParam:(NSString *)paramName value:(NSObject *)paramValue;
- (NSString *)buildStatement;
- (NSDictionary *)parameters;

@end
