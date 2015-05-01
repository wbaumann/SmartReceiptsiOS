//
//  DatabaseTestsBase.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <FMDB/FMDatabaseQueue.h>
#import "DatabaseTestsBase.h"
#import "Database.h"

@interface Database (TestExpose)

- (id)initWithDatabasePath:(NSString *)path;
- (BOOL)open:(BOOL)migrateDatabase;

@end

@implementation DatabaseTestsBase

- (NSString *)generateTestDBPath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"test_db_%d", (int) [NSDate timeIntervalSinceReferenceDate]]];
}

- (void)setUp {
    self.testDBPath = self.generateTestDBPath;
    [self setDb:[self createAndOpenDatabaseWithPath:self.testDBPath]];
}

- (void)tearDown {
    [self deleteTestDatabase];
}

- (void)deleteTestDatabase {
    [self.db close];
    [self setDb:nil];
    [[NSFileManager defaultManager] removeItemAtPath:self.testDBPath error:nil];
}

- (Database *)createAndOpenDatabaseWithPath:(NSString *)path {
    Database *db = [[Database alloc] initWithDatabasePath:path];
    [db open:NO];
    return db;
}


@end
