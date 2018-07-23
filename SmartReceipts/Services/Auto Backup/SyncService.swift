//
//  SyncService.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 15/07/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol SyncServiceProtocol {
    func syncDatabase()
    func uploadFile(receipt: WBReceipt)
}

class SyncService {
    static let shared = SyncService()
    
    private let network = NetworkReachabilityManager()
    
    private var syncService: SyncServiceProtocol?
    private var syncProvider: SyncProvider?
    
    private init() {
        updateSyncServiceIfNeeded()
        configureNetworkListener()
    }
    
    func initialize() {
        NotificationCenter.default.addObserver(self, selector: #selector(didInsert(_:)), name: .DatabaseDidInsertModel, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate(_:)), name: .DatabaseDidUpdateModel, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didDelete(_:)), name: .DatabaseDidDeleteModel, object: nil)
    }
    
    // MARK: - Private
    
    private func syncDatabase() {
        updateSyncServiceIfNeeded()
        syncService?.syncDatabase()
    }
    
    private func uploadFile(receipt: WBReceipt) {
        updateSyncServiceIfNeeded()
        syncService?.uploadFile(receipt: receipt)
    }
    
    private func updateSyncServiceIfNeeded() {
        if let provider = syncProvider, provider == SyncProvider.current { return }
        switch SyncProvider.current {
        case .googleDrive:
            syncService = GoogleSyncService()
            network?.startListening()
        case .none:
            syncService = nil
            network?.stopListening()
        }
        syncProvider = SyncProvider.current
    }
    
    private func configureNetworkListener() {
        network?.listener = { status in
            switch status {
            case .reachable(.wwan):
                if !WBPreferences.autobackupWifiOnly() { self.syncReceipts() }
            case .reachable(.ethernetOrWiFi):
                self.syncReceipts()
            default: break
            }
        }
    }
    
    private func syncReceipts() {
        
    }
    
    // MARK: - DB Handlers
    
    @objc private func didInsert(_ notification: Notification) {
        syncDatabase()
        guard let receipt = notification.object as? WBReceipt else { return }
        if !receipt.isSynced(syncProvider: .current) {
            let objectID = Database.sharedInstance().nextReceiptID() - UInt(1)
            guard let syncReceipt = Database.sharedInstance().receipt(byObjectID: objectID) else { return }
            syncReceipt.trip = receipt.trip
            uploadFile(receipt: syncReceipt)
        }
    }
    
    @objc private func didUpdate(_ notification: Notification)  {
        syncDatabase()
        guard let receipt = notification.object as? WBReceipt else { return }
        if !receipt.isSynced(syncProvider: .current) { uploadFile(receipt: receipt) }
    }
    
    @objc private func didDelete(_ notification: Notification)  {
        guard let receipt = notification.object as? WBReceipt else {
            syncDatabase()
            return
        }
        receipt.isMarkedForDeletion = true
        DispatchQueue.main.async {
            Database.sharedInstance().insert(receipt)
        }
    }
}


