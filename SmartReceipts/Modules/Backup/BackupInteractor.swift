//
//  BackupInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/02/2018.
//Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import Toaster

class BackupInteractor: Interactor {
    let bag = DisposeBag()
    
    var backupManager: BackupProvidersManager!
    let purchaseService = PurchaseService()
    
    required init() {
        backupManager = BackupProvidersManager(syncProvider: .current)
    }
    
    func hasValidSubscription() -> Bool {
        return purchaseService.hasValidSubscriptionValue()
    }
    
    func importBackup(_ backup: RemoteBackupMetadata, overwrite: Bool) {
        weak var hud = PendingHUDView.showFullScreen()
        backupManager?.restoreBackup(remoteBackupMetadata: backup, overwriteExistingData: overwrite)
            .andThen(self.backupManager.downloadAllData(remoteBackupMetadata: backup))
            .subscribe(onSuccess: { result in
                if !result.database.open() { return }
                let database = result.database
                let trips = database.allTrips() as! [WBTrip]
                for trip in trips {
                    let receipts = database.allReceipts(for: trip) as! [WBReceipt]
                    for receipt in receipts {
                        if !receipt.syncId.isEmpty {
                            let path = receipt.imageFilePath(for: trip)
                            let files = result.files
                            guard let file = files.filter({ path.contains($0.filename) }).first else { continue }
                            let folder = path.asNSString.deletingLastPathComponent
                            let fm = FileManager.default
                            if !fm.fileExists(atPath: folder) {
                                try? fm.createDirectory(atPath: folder, withIntermediateDirectories: true, attributes: nil)
                            }
                            fm.createFile(atPath: path, contents: file.data, attributes: nil)
                        }
                    }
                }
                hud?.hide()
                Toast.show(LocalizedString("toast_import_complete"))
            }, onError: { [weak self] error in
                hud?.hide()
                self?.presenter.presentAlert(title: nil, message: LocalizedString("IMPORT_ERROR"))
            }).disposed(by: bag)
    }
    
    func getBackups() -> Single<[RemoteBackupMetadata]> {
        return backupManager?.getRemoteBackups() ?? Single<[RemoteBackupMetadata]>.just([])
    }
    
    func purchaseSubscription() -> Observable<Void> {
        return purchaseService.purchaseSubscription().map({ _ -> Void in })
    }
    
    func saveCurrent(provider: SyncProvider) {
        if provider == .googleDrive {
            weak var hud = PendingHUDView.showFullScreen()
            GoogleDriveService.shared.signIn(onUI: presenter.signInUIDelegate())
                .subscribe(onNext: { [weak self] in
                    self?.setup(provider: .googleDrive)
                    hud?.hide()
                }, onError: { [weak self] error in
                    self?.setup(provider: .none)
                    hud?.hide()
                }).disposed(by: bag)
        } else {
            setup(provider: provider)
        }
    }
    
    func setupUseWifiOnly(enabled: Bool) {
        WBPreferences.setAutobackupWifiOnly(enabled)
    }
    
    private func setup(provider: SyncProvider) {
        backupManager = BackupProvidersManager(syncProvider: provider)
        SyncProvider.current = provider
        presenter.updateUI()
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension BackupInteractor {
    var presenter: BackupPresenter {
        return _presenter as! BackupPresenter
    }
}
