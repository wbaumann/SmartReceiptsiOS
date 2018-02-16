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

class BackupPresenter: Presenter {
    private let bag = DisposeBag()
    
    override func viewHasLoaded() {
        super.viewHasLoaded()
        
        view.importTap
            .subscribe(onNext: { [unowned self] in
                self.router.openBackupImport()
            }).disposed(by: bag)
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
