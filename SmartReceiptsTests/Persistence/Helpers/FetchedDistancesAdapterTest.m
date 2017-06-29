//
//  FetchedDistancesAdapterTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "FetchedModelAdapter.h"
#import "WBTrip.h"
#import "DatabaseTestsHelper.h"
#import "Database+Distances.h"
#import "FetchedModelAdapterDelegate.h"
#import "FetchAdapterDelegateCheckHelper.h"
#import "DatabaseTableNames.h"
#import <SmartReceipts-Swift.h>

@interface FetchedModelAdapter (TestExpose)

- (void)clearNotificationListener;
- (void)refreshContentAndNotifyInsertChanges;
- (void)refreshContentAndNotifyDeleteChanges;
- (void)refreshContentAndNotifyUpdateChanges:(NSObject *)updated;

@end

@interface FetchedDistancesAdapterTest : SmartReceiptsTestsBase

@property (nonatomic, strong) FetchedModelAdapter *adapter;
@property (nonatomic, strong) WBTrip *testTrip;

@end

@implementation FetchedDistancesAdapterTest

- (void)setUp {
    [super setUp];

    WBTrip *dummyTrip = [self.db createTestTrip];

    WBTrip *testTrip = [self.db createTestTrip];
    self.testTrip = testTrip;
    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT : dummyTrip}];
    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT : testTrip, DistanceTable.COLUMN_DATE : [NSDate date], DistanceTable.COLUMN_LOCATION : @"One"}];
    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT : dummyTrip}];
    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT : testTrip, DistanceTable.COLUMN_DATE : [[NSDate date] dateByAddingTimeInterval:-100], DistanceTable.COLUMN_LOCATION : @"Two"}];
    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT : dummyTrip}];
    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT : testTrip, DistanceTable.COLUMN_DATE : [[NSDate date] dateByAddingTimeInterval:100], DistanceTable.COLUMN_LOCATION : @"Three"}];
    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT : dummyTrip}];

    self.adapter = [self.db fetchedAdapterForDistancesInTrip:testTrip];
}

- (void)testAdapterFetchResult {
    XCTAssertEqual(3, self.adapter.numberOfObjects);
    Distance *first = [self.adapter objectAtIndex:0];
    XCTAssertNotNil(first);
    XCTAssertEqualObjects(@"Three", first.location);
}

- (void)testInsertWillBeNotified {
    [self.adapter clearNotificationListener];

    FetchAdapterDelegateCheckHelper *delegateCheck = [[FetchAdapterDelegateCheckHelper alloc] init];
    [self.adapter setDelegate:delegateCheck];

    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT : self.testTrip, DistanceTable.COLUMN_DATE : [[NSDate date] dateByAddingTimeInterval:10], DistanceTable.COLUMN_LOCATION : @"Four"}];

    [self.adapter refreshContentAndNotifyInsertChanges];

    XCTAssertTrue(delegateCheck.willChangeCalled);
    XCTAssertEqual(1, delegateCheck.insertIndex);
    Distance *insertObject = delegateCheck.insertObject;
    XCTAssertEqualObjects(@"Four", insertObject.location);
    XCTAssertNil(delegateCheck.deleteObject);
    XCTAssertTrue(delegateCheck.didChangeCalled);
}

- (void)testDeleteWillBeNotified {
    [self.adapter clearNotificationListener];

    FetchAdapterDelegateCheckHelper *delegateCheck = [[FetchAdapterDelegateCheckHelper alloc] init];
    [self.adapter setDelegate:delegateCheck];

    NSUInteger count = self.adapter.numberOfObjects;
    NSUInteger removeIndex = count - 1;
    id removed = [self.adapter objectAtIndex:removeIndex];
    [self.db deleteDistance:removed];

    [self.adapter refreshContentAndNotifyDeleteChanges];

    XCTAssertTrue(delegateCheck.willChangeCalled);
    XCTAssertEqual(removeIndex, delegateCheck.deleteIndex);
    Distance *deleteObject = delegateCheck.deleteObject;
    XCTAssertEqualObjects(removed, deleteObject);
    XCTAssertNil(delegateCheck.insertObject);
    XCTAssertTrue(delegateCheck.didChangeCalled);
}

- (void)testUpdateWillBeNotified {
    [self.adapter clearNotificationListener];

    FetchAdapterDelegateCheckHelper *delegateCheck = [[FetchAdapterDelegateCheckHelper alloc] init];
    [self.adapter setDelegate:delegateCheck];

    NSUInteger count = self.adapter.numberOfObjects;
    NSUInteger updateIndex = MIN(2, count - 1);
    Distance *updated = [self.adapter objectAtIndex:updateIndex];
    updated.location = @"Updated location";
    [self.db saveDistance:updated];

    [self.adapter refreshContentAndNotifyUpdateChanges:updated];

    XCTAssertTrue(delegateCheck.willChangeCalled);
    XCTAssertEqual(updateIndex, delegateCheck.updateIndex);
    Distance *updatedObject = [self.adapter objectAtIndex:updateIndex];
    XCTAssertEqualObjects(updated.location, updatedObject.location);
    XCTAssertNil(delegateCheck.insertObject);
    XCTAssertTrue(delegateCheck.didChangeCalled);
}

- (void)testMoveWillBeNotified {
    [self.adapter clearNotificationListener];

    FetchAdapterDelegateCheckHelper *delegateCheck = [[FetchAdapterDelegateCheckHelper alloc] init];
    [self.adapter setDelegate:delegateCheck];

    NSUInteger beginIndex = 0;
    NSUInteger endIndex = 2;
    Distance *updated = [self.adapter objectAtIndex:beginIndex];
    updated.date = [[NSDate date] dateByAddingTimeInterval:-1000000];
    [self.db saveDistance:updated];

    [self.adapter refreshContentAndNotifyUpdateChanges:updated];

    XCTAssertTrue(delegateCheck.willChangeCalled);
    XCTAssertEqual(beginIndex, delegateCheck.moveFromIndex);
    XCTAssertEqual(endIndex, delegateCheck.moveToIndex);
    XCTAssertTrue(delegateCheck.didChangeCalled);
}

@end
