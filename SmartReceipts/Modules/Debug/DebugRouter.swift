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
        return AnyObserver<Void>(eventHandler: { [unowned self] event in
            switch event {
            case .next:
                let module = AppModules.auth.build()
                module.router.show(from: self._view)
            default: break
            }
        })
    }
    
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension DebugRouter {
    var presenter: DebugPresenter {
        return _presenter as! DebugPresenter
    }
}
