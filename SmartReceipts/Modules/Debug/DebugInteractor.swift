//
//  DebugInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import Toaster

class DebugInteractor: Interactor {
    private let bag = DisposeBag()
    var debugSubscription: AnyObserver<Bool> {
        return AnyObserver<Bool>(onNext: { value in
            DebugStates.setSubscription(value)
        })
    }
    
    var loginTest: AnyObserver<Void> {
        return AnyObserver<Void>(onNext: { [unowned self] in
            AuthService.shared.login(credentials: Credentials("aaa@aaa.aaa", "12345678"))
                .subscribe(onNext: { _ in
                    Toast(text: "Logged In: aaa@aaa.aaa").show()
                }).disposed(by: self.bag)
        })
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension DebugInteractor {
    var presenter: DebugPresenter {
        return _presenter as! DebugPresenter
    }
}
