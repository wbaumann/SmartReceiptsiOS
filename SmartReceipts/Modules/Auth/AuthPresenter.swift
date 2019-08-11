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

protocol AuthModuleInterface: class {
    var successAuth: Observable<Void> { get }
    func close()
}

class AuthPresenter: Presenter {
    let bag = DisposeBag()
    let successAuthSubject = PublishSubject<Void>()
    
    override func viewHasLoaded() {
        view.login
            .bind(to: interactor.login)
            .disposed(by: bag)
        
        view.signup
            .bind(to: interactor.signup)
            .disposed(by: bag)
        
        view.logoutTap
            .bind(to: interactor.logout)
            .disposed(by: bag)
    }
    
    var successLogin: AnyObserver<Void> {
        return view.successLoginHandler
    }
    
    var successSignup: AnyObserver<Void> {
        return view.successSignupHandler
    }
    
    var successLogout: AnyObserver<Void> {
        return view.successLogoutHandler
    }
    
    var errorHandler: AnyObserver<String> {
        return view.errorHandler
    }
}

extension AuthPresenter: AuthModuleInterface {
    var successAuth: Observable<Void> { return successAuthSubject.asObservable() }
    
    func close() {
        router.close()
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
