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

class DebugInteractor: Interactor {
    var debugSubscription: AnyObserver<Bool> {
        return AnyObserver<Bool>(eventHandler: { event in
            DebugStates.setSubscription(event.element!)
        })
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension DebugInteractor {
    var presenter: DebugPresenter {
        return _presenter as! DebugPresenter
    }
}
