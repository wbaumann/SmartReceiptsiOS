//
//  DatabaseTestVersion13.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 15/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DatabaseTestsBase.h"

@interface DatabaseTestVersion13 : DatabaseTestsBase

@end

@implementation DatabaseTestVersion13

- (void)setUp {
    [super setUp];

    self.db = [self createAndOpenDatabaseWithPath:self.testDBPath migrated:YES];
}

- (void)testDatabasesSame {
    [self checkDatabasesSame:[[NSBundle bundleForClass:[self class]] pathForResource:@"android-receipts-v13" ofType:@"db"] checked:self.testDBPath];
}

@end
