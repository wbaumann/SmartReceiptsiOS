//
//  DatabaseTestVersion13.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 15/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "DatabaseUpgradeToVersion13.h"
#import "DatabaseUpgradeToVersion12.h"
#import "DatabaseCreateAtVersion11.h"

@interface DatabaseMigration (TestsExpose)

+ (BOOL)runMigrations:(NSArray *)migrations onDatabase:(Database *)database;

@end

@interface DatabaseTestVersion13 : SmartReceiptsTestsBase

@end

@implementation DatabaseTestVersion13

- (void)setUp {
    [super setUp];

    self.db = [self createAndOpenDatabaseWithPath:self.testDBPath migrated:NO];
    NSArray *migrations = @[
            [[DatabaseCreateAtVersion11 alloc] init],
            [[DatabaseUpgradeToVersion12 alloc] init],
            [[DatabaseUpgradeToVersion13 alloc] init]
    ];
    [DatabaseMigration runMigrations:migrations onDatabase:self.db];
}

- (void)testDatabasesSame {
    [self checkDatabasesSame:[[NSBundle bundleForClass:[self class]] pathForResource:@"android-receipts-v13" ofType:@"db"] checked:self.testDBPath];
}

@end
