//
//  WBColumn+WBDB.h
//  SmartReceipts
//
//  Created on 20/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBColumnNames.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface WBColumnsHelper : NSObject

+ (NSString*) TABLE_NAME_CSV;
+ (NSString*) TABLE_NAME_PDF;

- (id)initWithDatabaseQueue:(FMDatabaseQueue*) db tableName:(NSString*) tabName;

- (BOOL) createTable;

-(NSArray*) selectAll;
-(BOOL) insertWithColumnName:(NSString*) columnName;
-(BOOL) updateWithIndex:(int) index name:(NSString*) name;
-(BOOL) deleteWithIndex:(int) index;

-(BOOL) deleteAllAndInsertColumns:(NSArray*) columns;

+(BOOL) mergeDatabase:(FMDatabase*) currDB withDatabase:(FMDatabase*) importDB forTable:(NSString*) tableName;

@end
