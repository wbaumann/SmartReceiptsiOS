//
//  AuthInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import Alamofire

fileprivate let ACCOUNT_ALREADY_EXISTS_CODE = 420
fileprivate let INVALID_CREDENTIALS_CODE = 401

class AuthInteractor: Interactor {
    private var authService: AuthService = AuthService()
    private let bag = DisposeBag()
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    required init() {}
    
    var login: AnyObserver<Credentials> {
        return AnyObserver<Credentials>(eventHandler: { [unowned self] event in
            switch event {
            case .next(let credentials):
                self.authService.login(credentials: credentials)
                    .catchError({ error -> Observable<String> in
                        let afError = error as! AFError
                        let errorText = afError.responseCode == INVALID_CREDENTIALS_CODE ?
                            LocalizedString("login.error.login.failed") : error.localizedDescription
                        self.presenter.errorHandler.onNext(errorText)
                        return Observable.just("")
                    }).filter({ $0 != ""})
                    .bind(to: self.presenter.successLogin)
                    .disposed(by: self.bag)
            default: break
            }
        })
    }
    
    var signup: AnyObserver<Credentials> {
        return AnyObserver<Credentials>(eventHandler: { [unowned self] event in
            switch event {
            case .next(let credentials):
                self.authService.signup(credentials: credentials)
                    .catchError({ error -> Observable<String> in
                        let afError = error as! AFError
                        let errorText = afError.responseCode == ACCOUNT_ALREADY_EXISTS_CODE ?
                            LocalizedString("login.error.signup.failed") : error.localizedDescription
                        self.presenter.errorHandler.onNext(errorText)
                        return Observable.just("")
                    }).filter({ $0 != ""})
                    .bind(to: self.presenter.successSignup)
                    .disposed(by: self.bag)
            default: break
            }
        })
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension AuthInteractor {
    var presenter: AuthPresenter {
        return _presenter as! AuthPresenter
    }
}
