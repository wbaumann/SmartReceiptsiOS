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
import Toaster

fileprivate let ACCOUNT_ALREADY_EXISTS_CODE = 420
fileprivate let INVALID_CREDENTIALS_CODE = 401

class AuthInteractor: Interactor {
    private var authService: AuthService = AuthService.shared
    private let cognitoService = CognitoService()
    private let bag = DisposeBag()
    
    var login: AnyObserver<Credentials> {
        return AnyObserver<Credentials>(eventHandler: { [unowned self] event in
            switch event {
            case .next(let credentials):
                self.authService.login(credentials: credentials)
                    .catchError({ error -> Observable<String> in
                        if let afError = error as? AFError, afError.responseCode == INVALID_CREDENTIALS_CODE {
                            self.presenter.errorHandler.onNext(LocalizedString("login.error.login.failed"))
                        } else {
                            self.presenter.errorHandler.onNext(error.localizedDescription)
                        }
                        return Observable.never()
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
                        if let afError = error as? AFError, afError.responseCode == ACCOUNT_ALREADY_EXISTS_CODE {
                            self.presenter.errorHandler.onNext(LocalizedString("login.error.signup.failed"))
                        } else {
                            self.presenter.errorHandler.onNext(error.localizedDescription)
                        }
                        return Observable.never()
                    }).filter({ $0 != ""})
                    .bind(to: self.presenter.successSignup)
                    .disposed(by: self.bag)
            default: break
            }
        })
    }
    
    var logout: AnyObserver<Void> {
        return AnyObserver<Void>(eventHandler: { [unowned self] event in
            switch event {
            case .next:
                self.authService.logout()
                    .catchError({ error -> Observable<Void> in
                        self.presenter.errorHandler.onNext(error.localizedDescription)
                        return Observable.never()
                    }).bind(to: self.presenter.successLogout)
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
