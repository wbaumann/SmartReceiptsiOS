//
//  SettingsPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class SettingsPresenter: Presenter {
    
    private let bag = DisposeBag()
    
    override func viewHasLoaded() {
        super.viewHasLoaded()
        
        view.doneButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.router.close()
        }).disposed(by: bag)
        
    }
    
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension SettingsPresenter {
    var view: SettingsViewInterface {
        return _view as! SettingsViewInterface
    }
    var interactor: SettingsInteractor {
        return _interactor as! SettingsInteractor
    }
    var router: SettingsRouter {
        return _router as! SettingsRouter
    }
}
