//
//  DebugPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class DebugPresenter: Presenter {
    let bag = DisposeBag()
    
    override func viewHasLoaded() {
        view.loginTap
            .bind(to: router.loginTapSubscriber)
            .disposed(by: bag)
    }
    
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension DebugPresenter {
    var view: DebugViewInterface {
        return _view as! DebugViewInterface
    }
    var interactor: DebugInteractor {
        return _interactor as! DebugInteractor
    }
    var router: DebugRouter {
        return _router as! DebugRouter
    }
}
