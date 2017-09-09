//
//  AuthPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import Toaster

class AuthPresenter: Presenter {
    
    let bag = DisposeBag()
    
    override func viewHasLoaded() {
        view.login
            .bind(to: interactor.login)
            .disposed(by: bag)
        
        view.signup
            .bind(to: interactor.signup)
            .disposed(by: bag)
    }
    
    var successLogin: AnyObserver<String> {
        return AnyObserver<String>(eventHandler: { [weak self] event in
            self?.view.requestComplete.onNext()
            switch event {
            case .next(let token):
                Logger.debug("Success login: \(token)")
                Toast.show(LocalizedString("login.success.login.toast"))
            default: break
            }
        })
    }
    
    var successSignup: AnyObserver<String> {
        return AnyObserver<String>(eventHandler: { [weak self] event in
            self?.view.requestComplete.onNext()
            switch event {
            case .next(let token):
                Logger.debug("Success signup: \(token)")
                Toast.show(LocalizedString("login.success.signup.toast"))
            default: break
            }
        })
    }
    
    var errorHandler: AnyObserver<String> {
        return view.errorHandler
    }
    
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension AuthPresenter {
    var view: AuthViewInterface {
        return _view as! AuthViewInterface
    }
    var interactor: AuthInteractor {
        return _interactor as! AuthInteractor
    }
    var router: AuthRouter {
        return _router as! AuthRouter
    }
}
