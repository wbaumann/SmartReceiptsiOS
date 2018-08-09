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
    func deleteFile(receipt: WBReceipt)
    func replaceFile(receipt: WBReceipt)
}

class SyncService {
    static let shared = SyncService()
    
    private let bag = DisposeBag()
    private let network = NetworkReachabilityManager()
    
    private var syncService: SyncServiceProtocol?
    private var syncProvider: SyncProvider?
    
    private init() {
        GoogleDriveService.shared.signInSilently()
            .subscribe({ _ in
                self.updateSyncServiceIfNeeded()
                self.configurePreferencesListeners()
                self.configureNetworkListener()
            }).disposed(by: bag)
    }
    
    func initialize() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(didInsert(_:)), name: .DatabaseDidInsertModel, object: nil)
        center.addObserver(self, selector: #selector(didUpdate(_:)), name: .DatabaseDidUpdateModel, object: nil)
        center.addObserver(self, selector: #selector(didDelete(_:)), name: .DatabaseDidDeleteModel, object: nil)
    }
    
    // MARK: - Configurations
    
    private func configurePreferencesListeners() {
        AppNotificationCenter.preferencesWiFiOnly
            .skipFirst()
            .subscribe(onNext: { wifiOnly in
                self.syncReceipts()
            }).disposed(by: bag)
        
        AppNotificationCenter.syncProvider
            .skipFirst()
            .subscribe(onNext: { provider in
                self.updateSyncServiceIfNeeded()
                self.syncReceipts()
            }).disposed(by: bag)
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
    
    // MARK: - Private
    
    private func syncReceipts() {
        var markedReceipts: [WBReceipt]!
        var unsyncedReceipts: [WBReceipt]!
        
        Database.sharedInstance().databaseQueue.inDatabase { db in
            markedReceipts = db.fetchAllMarkedForDeletionReceipts()
            unsyncedReceipts = db.fetchAllUnsyncedReceipts()
        }
        
        for receipt in markedReceipts {
            if !receipt.isSynced(syncProvider: .current) {
                deleteFile(receipt: receipt)
            } else {
                Database.sharedInstance().delete(receipt)
            }
        }
        
        for receipt in unsyncedReceipts {
            if !receipt.isMarkedForDeletion(syncProvider: .current) {
                guard let trip = Database.sharedInstance().tripWithName(receipt.tripName) else { continue }
                receipt.trip = trip
                syncService?.uploadFile(receipt: receipt)
            }
        }
    }
    
    func deleteFile(receipt: WBReceipt) {
        syncService?.deleteFile(receipt: receipt)
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
    
    // MARK: - DB Handlers
    
    @objc private func didInsert(_ notification: Notification) {
        syncService?.syncDatabase()
        guard let receipt = notification.object as? WBReceipt else { return }
        if !receipt.isSynced(syncProvider: .current) {
            let objectID = Database.sharedInstance().nextReceiptID() - UInt(1)
            guard let syncReceipt = Database.sharedInstance().receipt(byObjectID: objectID) else { return }
            syncReceipt.trip = receipt.trip
            syncService?.uploadFile(receipt: syncReceipt)
        }
    }
    
    @objc private func didUpdate(_ notification: Notification)  {
        syncService?.syncDatabase()
        guard let receipt = notification.object as? WBReceipt else { return }
        if !receipt.isSynced(syncProvider: .current) && !receipt.isMarkedForDeletion(syncProvider: .current) {
            let upload = receipt.getSyncId(provider: .current)?.isEmpty ?? true
            upload ? syncService?.uploadFile(receipt: receipt) : syncService?.replaceFile(receipt: receipt)
        } else if !receipt.isSynced(syncProvider: .current) && receipt.isMarkedForDeletion(syncProvider: .current) {
            deleteFile(receipt: receipt)
        }
    }
    
    @objc private func didDelete(_ notification: Notification)  {
        syncService?.syncDatabase()
    }
}


