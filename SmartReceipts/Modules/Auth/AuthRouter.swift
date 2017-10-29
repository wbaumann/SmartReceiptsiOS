//
//  AuthRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class AuthRouter: Router {
    func close() {
        _view.dismiss(animated: true, completion: nil)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension AuthRouter {
    var presenter: AuthPresenter {
        return _presenter as! AuthPresenter
    }
}
