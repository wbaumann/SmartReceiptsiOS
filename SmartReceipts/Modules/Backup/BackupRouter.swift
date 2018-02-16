//
//  BackupRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/02/2018.
//Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class BackupRouter: Router {
    private let bag = DisposeBag()
    
    func openBackupImport() {
        BackupFilePicker.sharedInstance.openFilePicker(on: self._view)
            .subscribe(onNext: { smrURL in
                (UIApplication.shared.delegate as? AppDelegate)?.handleSMR(url: smrURL)
            }).disposed(by: bag)
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension BackupRouter {
    var presenter: BackupPresenter {
        return _presenter as! BackupPresenter
    }
}
