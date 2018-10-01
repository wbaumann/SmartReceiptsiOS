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
    func getCriticalSyncErrorStream() -> Observable<SyncError?>
}

class SyncService {
    static let shared = SyncService()
    
    private let bag = DisposeBag()
    private let network = NetworkReachabilityManager()
    
    private var syncService: SyncServiceProtocol?
    private var syncProvider: SyncProvider?
    private var syncErrorsSubject = BehaviorSubject<SyncError?>(value: nil)
    
    private init() {
        GoogleDriveService.shared.signInSilently()
            .subscribe({ _ in
                self.updateSyncServiceIfNeeded()
                self.configurePreferencesListeners()
                self.configureNetworkListener()
            }).disposed(by: bag)
    }
    
    private var canUploadReceipts: Bool {
        guard let net = network else { return false }
        return !WBPreferences.autobackupWifiOnly() || net.isReachableOnEthernetOrWiFi
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
            .subscribe(onNext: { wifiOnly in
                self.syncReceipts()
            }).disposed(by: bag)
        
        AppNotificationCenter.syncProvider
            .subscribe(onNext: { provider in
                self.updateSyncServiceIfNeeded()
                self.syncService?.syncDatabase()
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
    
    func trySyncData() {
        syncService?.syncDatabase()
        syncReceipts()
    }
    
    // MARK: - Private
    
    private func syncReceipts() {
        if !canUploadReceipts { return }
        
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
        
        unsyncedReceipts.asObservable()
            .delayEach(seconds: 0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] receipt in
                if !receipt.isMarkedForDeletion(syncProvider: .current) {
                    guard let trip = Database.sharedInstance().tripWithName(receipt.tripName) else { return }
                    receipt.trip = trip
                    self.syncService?.uploadFile(receipt: receipt)
                }
            }).disposed(by: bag)
    }
    
    func deleteFile(receipt: WBReceipt) {
        syncService?.deleteFile(receipt: receipt)
    }
    
    func getCriticalSyncErrorStream() -> Observable<SyncError?> {
        return syncErrorsSubject.asObservable()
    }
    
    func markErrorResolved(syncErrorType: SyncError) {
        guard let currentError = try? syncErrorsSubject.value() else { return }
        if syncErrorType == currentError {
            syncErrorsSubject.onNext(nil)
        }
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
        syncService?.getCriticalSyncErrorStream().bind(to: syncErrorsSubject).disposed(by: bag)
    }

    // MARK: - DB Handlers
    
    @objc private func didInsert(_ notification: Notification) {
        syncService?.syncDatabase()
        if !canUploadReceipts { return }
        
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
        if !canUploadReceipts { return }
        
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


