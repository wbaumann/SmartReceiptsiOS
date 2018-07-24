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

class BackupInteractor: Interactor {
    let bag = DisposeBag()
    
    var backupManager: BackupProvidersManager?
    
    let purchaseService = PurchaseService()
    
    func hasValidSubscription() -> Bool {
        return purchaseService.hasValidSubscriptionValue()
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
