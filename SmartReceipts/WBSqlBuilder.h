//
//  WBSqlBuilder.h
//  SmartReceipts
//
//  Created on 29/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Helper class for organizng long sql statements.
 */



@interface WBSqlBuilder : NSObject

@property NSMutableArray* columns;
@property NSMutableArray* values;

-(void) addColumn:(NSString*) columnName andObject:(NSObject*) valueObject;
-(void) addColumn:(NSString*) columnName andInt:(int) valueInt;
-(void) addColumn:(NSString*) columnName andBoolean:(BOOL) valueBool;

-(void) addColumn:(NSString*) columnName;

-(void) addValue:(NSObject*) valueObject;
-(void)addValueFromInt:(NSInteger) valueInt;
-(void) addValueFromBoolean:(BOOL) valueBoolean;

-(NSString*) columnsStringForInsert;
-(NSString*) columnsStringForUpdate;
-(NSString*) questionMarksStringForInsert;

+(NSString*) columnsStringForInsertWithColumns:(NSArray*) columns;
+(NSString*) columnsStringForUpdateWithColumns:(NSArray*) columns;
+(NSString*) questionMarksStringForInsertWithColumns:(NSArray*) columns;

@end
