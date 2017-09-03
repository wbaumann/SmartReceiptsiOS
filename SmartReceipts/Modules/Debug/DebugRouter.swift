//
//  DebugRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class DebugRouter: Router {
    
    var loginTapSubscriber: AnyObserver<Void> {
        return AnyObserver<Void>(eventHandler: { _ in
            Logger.debug("Login tap!")
        })
    }
    
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension DebugRouter {
    var presenter: DebugPresenter {
        return _presenter as! DebugPresenter
    }
}
