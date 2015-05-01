//
//  DatabaseTestsBase.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

@class FMDatabaseQueue;
@class Database;

@interface DatabaseTestsBase : XCTestCase

@property (nonatomic, copy) NSString *testDBPath;
@property (nonatomic, strong) Database *db;

- (void)deleteTestDatabase;
- (Database *)createAndOpenDatabaseWithPath:(NSString *)path;

@end
