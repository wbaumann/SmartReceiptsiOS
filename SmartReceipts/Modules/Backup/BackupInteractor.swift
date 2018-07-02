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
        SyncProvider.current = provider
        backupManager = BackupProvidersManager(syncProvider: provider)
        
        if provider == .googleDrive {
            GoogleDriveService.shared.signIn(onUI: presenter.signInUIDelegate())
                .subscribe(onNext: {
                    
                }, onError: { error in
                    
                }).disposed(by: bag)
        }
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension BackupInteractor {
    var presenter: BackupPresenter {
        return _presenter as! BackupPresenter
    }
}
