//
//  SettingsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class SettingsRouter: Router {
    
    func close() {
        _view.dismiss(animated: true, completion: nil)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension SettingsRouter {
    var presenter: SettingsPresenter {
        return _presenter as! SettingsPresenter
    }
}
