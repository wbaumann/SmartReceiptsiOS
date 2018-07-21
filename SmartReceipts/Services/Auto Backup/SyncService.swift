//
//  SyncService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/07/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

protocol SyncServiceProtocol {
    func syncDatabase()
    func uploadFile(receipt: WBReceipt)
}

class SyncService: SyncServiceProtocol {
    static let shared = SyncService()
    
    private var syncService: SyncServiceProtocol!
    private var syncProvider: SyncProvider?
    
    private init() {
        updateSyncServiceIfNeeded()
    }
    
    func syncDatabase() {
        updateSyncServiceIfNeeded()
        syncService.syncDatabase()
    }
    
    func uploadFile(receipt: WBReceipt) {
        updateSyncServiceIfNeeded()
        return syncService.uploadFile(receipt: receipt)
    }
    
    private func updateSyncServiceIfNeeded() {
        if let provider = syncProvider, provider == SyncProvider.current { return }
        switch SyncProvider.current {
        case .googleDrive:
            syncService = GoogleSyncService()
        case .none:
            syncService = NoOpSyncService()
        }
        syncProvider = SyncProvider.current
    }
}

fileprivate class NoOpSyncService: SyncServiceProtocol {
    func syncDatabase() {}
    func uploadFile(receipt: WBReceipt) {}
}
