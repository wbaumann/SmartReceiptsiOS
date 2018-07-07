//
//  SyncMapsTests.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 29/06/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
@testable import SmartReceipts

class SyncMapsTests: XCTestCase {
    
    func testSyncStatusMap() {
        let emptyMap = SyncStatusMap()
        XCTAssertFalse(emptyMap.isSynced(provider: .googleDrive))
        XCTAssertFalse(emptyMap.isSynced(provider: .none))
        
        let googleSynced = SyncStatusMap(map: [.googleDrive : true])
        XCTAssertTrue(googleSynced.isSynced(provider: .googleDrive))
        XCTAssertFalse(googleSynced.isSynced(provider: .none))
    }
    
    func testMarkedForDeletionMap() {
        let emptyMap = MarkedForDeletionMap()
        XCTAssertFalse(emptyMap.isMarkedForDeletion(provider: .googleDrive))
        XCTAssertFalse(emptyMap.isMarkedForDeletion(provider: .none))
        
        let googleMarked = MarkedForDeletionMap(map: [.googleDrive : true])
        XCTAssertTrue(googleMarked.isMarkedForDeletion(provider: .googleDrive))
        XCTAssertFalse(googleMarked.isMarkedForDeletion(provider: .none))
    }
    
    func testIdentifierMap() {
        let emptyMap = IdentifierMap()
        XCTAssertNil(emptyMap.syncId(provider: .googleDrive))
        XCTAssertNil(emptyMap.syncId(provider: .none))
        
        let drive = "drive"
        let googleMarked = IdentifierMap(map: [.googleDrive : drive])
        XCTAssertEqual(googleMarked.syncId(provider: .googleDrive), drive)
        XCTAssertNil(googleMarked.syncId(provider: .none))
    }
    
    func testEmptyDefaultSyncState() {
        let emptyIdentifierMap = IdentifierMap()
        let emptySyncStatusMap = SyncStatusMap()
        let emptyDeletionMap = MarkedForDeletionMap()
        
        let syncState = DefaultSyncState(identifierMap: emptyIdentifierMap, syncStatusMap: emptySyncStatusMap, markedForDeletionMap: emptyDeletionMap, lastModificationDate: nil)
        
        XCTAssertFalse(syncState.isMarkedForDeletion(syncProvider: .googleDrive))
        XCTAssertFalse(syncState.isMarkedForDeletion(syncProvider: .none))
        
        XCTAssertFalse(syncState.isSynced(syncProvider: .googleDrive))
        XCTAssertFalse(syncState.isSynced(syncProvider: .none))
        
        XCTAssertNil(syncState.getSyncId(provider: .googleDrive))
        XCTAssertNil(syncState.getSyncId(provider: .none))
        
        XCTAssertNotNil(syncState.lastLocalModificationTime)
    }
    
    func testDriveDefaultSyncState() {
        let drive = "drive"
        let identifierMap = IdentifierMap(map: [.googleDrive : drive])
        let delitionMap = MarkedForDeletionMap(map: [.googleDrive : true])
        let statusMap = SyncStatusMap(map: [.googleDrive : true])
        let lastModificationDate = Date()
        
        let syncState = DefaultSyncState(identifierMap: identifierMap, syncStatusMap: statusMap, markedForDeletionMap: delitionMap, lastModificationDate: lastModificationDate)
        
        XCTAssertTrue(syncState.isMarkedForDeletion(syncProvider: .googleDrive))
        XCTAssertFalse(syncState.isMarkedForDeletion(syncProvider: .none))
        
        XCTAssertTrue(syncState.isSynced(syncProvider: .googleDrive))
        XCTAssertFalse(syncState.isSynced(syncProvider: .none))
        
        XCTAssertEqual(syncState.getSyncId(provider: .googleDrive), drive)
        XCTAssertNil(syncState.getSyncId(provider: .none))
        
        XCTAssertEqual(syncState.lastLocalModificationTime, lastModificationDate)
    }
    
}
