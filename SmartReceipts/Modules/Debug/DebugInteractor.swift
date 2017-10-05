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
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension DebugInteractor {
    var presenter: DebugPresenter {
        return _presenter as! DebugPresenter
    }
}
