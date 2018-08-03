//
//  BackupPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/02/2018.
//Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import GoogleSignIn

class BackupPresenter: Presenter {
    private let bag = DisposeBag()
    
    override func viewHasLoaded() {
        super.viewHasLoaded()
        
        view.importTap
            .subscribe(onNext: { [unowned self] in
                self.router.openBackupImport()
            }).disposed(by: bag)
    }
    
    func getBackups() -> Single<[RemoteBackupMetadata]> {
        return interactor.getBackups()
    }
    
    func hasValidSubscription() -> Bool {
        return true
        return interactor.hasValidSubscription()
    }
    
    func purchaseSubscription() -> Observable<Void> {
        return interactor.purchaseSubscription()
    }
    
    func signInUIDelegate() -> GIDSignInUIDelegate {
        return view.signInUIDelegate
    }
    
    func saveCurrent(provider: SyncProvider) {
        interactor.saveCurrent(provider: provider)
    }
    
    func updateUI() {
        view.updateUI()
    }
    
    func setupUseWifiOnly(enabled: Bool) {
        interactor.setupUseWifiOnly(enabled: enabled)
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension BackupPresenter {
    var view: BackupViewInterface {
        return _view as! BackupViewInterface
    }
    var interactor: BackupInteractor {
        return _interactor as! BackupInteractor
    }
    var router: BackupRouter {
        return _router as! BackupRouter
    }
}
