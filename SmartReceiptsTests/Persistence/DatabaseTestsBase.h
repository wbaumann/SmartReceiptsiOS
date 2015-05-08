//
//  DatabaseTestsBase.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

@class FMDatabaseQueue;
@class Database;
@class DatabaseTestsHelper;

@interface DatabaseTestsBase : XCTestCase

@property (nonatomic, copy) NSString *testDBPath;
@property (nonatomic, strong) DatabaseTestsHelper *db;

- (void)deleteTestDatabase;
- (DatabaseTestsHelper *)createAndOpenUnmigratedDatabaseWithPath:(NSString *)path;
- (DatabaseTestsHelper *)createAndOpenDatabaseWithPath:(NSString *)path migrated:(BOOL)migrated;
- (DatabaseTestsHelper *)createTestDatabase;

@end
