//
//  FetchedModelAdapterTests.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 17/08/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import XCTest
import RxTest
import RxSwift


class FetchedModelAdapterTests: SmartReceiptsTestsBase {
    
    var testTrip: WBTrip!
    var fetchedModelAdapter: FetchedModelAdapter!
    
    override func setUp() {
        super.setUp()
        testTrip = db.createTestTrip()
        fetchedModelAdapter = db.fetchedAdapterForDistances(in: testTrip)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAdapterWillChange() {
        let scheduler = TestScheduler(initialClock: 0)
        let willChangeObserver = scheduler.createObserver(Void.self)
        _ = fetchedModelAdapter.rx.willChangeContent.bind(to: willChangeObserver)
        
        let location = "Moscow"
        _ = insertTestDinstance(location)
        
        XCTAssertTrue(willChangeObserver.testEvents(count: 1))
        XCTAssertFalse(willChangeObserver.testEvents(count: 2))
    }
    
    func testAdapterDidChange() {
        let scheduler = TestScheduler(initialClock: 0)
        let didChangeObserver = scheduler.createObserver(Void.self)
        _ = fetchedModelAdapter.rx.didChangeContent.bind(to: didChangeObserver)
        
        let location = "New York"
        _ = insertTestDinstance(location)
        
        XCTAssertTrue(didChangeObserver.testEvents(count: 1))
        XCTAssertFalse(didChangeObserver.testEvents(count: 2))
    }
    
    func testAdapterInsert() {
        let scheduler = TestScheduler(initialClock: 0)
        let didInsertObserver = scheduler.createObserver(FetchedObjectAction.self)
        _ = fetchedModelAdapter.rx.didInsert.bind(to: didInsertObserver)
        
        let location = "Dubai"
        _ = insertTestDinstance(location)
        
        XCTAssertTrue(didInsertObserver.testEvents(count: 1))
        XCTAssertFalse(didInsertObserver.testEvents(count: 2))
        
        let inserted = didInsertObserver.events.first!.value.element!.object as! Distance
        XCTAssertTrue(inserted.location == location)
        XCTAssertFalse(inserted.location == "Moscow")
    }
    
    func testAdapterUpdate() {
        let scheduler = TestScheduler(initialClock: 0)
        let didUpdateObserver = scheduler.createObserver(FetchedObjectAction.self)
        _ = fetchedModelAdapter.rx.didUpdate.bind(to: didUpdateObserver)
        
        let location = "Los Angeles"
        let inserted = insertTestDinstance(location)
        
        let forUpdate = fetchedModelAdapter.object(at: 0) as! Distance
        forUpdate.distance = NSDecimalNumber(decimal: 120.0)
        forUpdate.comment = "Comment"
        
        db.save(forUpdate)
        fetchedModelAdapter.refreshContentAndNotifyUpdateChanges(forUpdate)
        
        XCTAssertTrue(didUpdateObserver.testEvents(count: 1))
        XCTAssertFalse(didUpdateObserver.testEvents(count: 2))
        
        let updated = didUpdateObserver.events.first!.value.element!.object as! Distance
        XCTAssertTrue(inserted.location == updated.location)
        XCTAssertFalse(inserted.comment == updated.comment)
        XCTAssertFalse(inserted.distance == updated.distance)
    }
    
    func testAdapterDelete() {
        let scheduler = TestScheduler(initialClock: 0)
        let didDeleteObserver = scheduler.createObserver(FetchedObjectAction.self)
        _ = fetchedModelAdapter.rx.didDelete.bind(to: didDeleteObserver)
        
        let location = "Male"
        let inserted = insertTestDinstance(location)
        
        db.delete(inserted)
        fetchedModelAdapter.refreshContentAndNotifyDeleteChanges()
        
        XCTAssertTrue(didDeleteObserver.testEvents(count: 1))
        XCTAssertFalse(didDeleteObserver.testEvents(count: 2))
    }

    private func insertTestDinstance(_ location: String) -> Distance {
        fetchedModelAdapter.clearNotificationListener()
        let testDistance = Distance(trip: testTrip,
                                distance: NSDecimalNumber(value: 5),
                                    rate: Price(currencyCode: "USD"),
                                location: location,
                                    date: Date(), timeZone: TimeZone.current, comment: nil)
        db.save(testDistance)
        fetchedModelAdapter.refreshContentAndNotifyInsertChanges()
        return testDistance
    }
}

extension TestableObserver {
    func testEvents(count: Int) -> Bool {
        return self.events.count == count
    }
}
