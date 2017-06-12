//
//  EditTripRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class EditTripRouter: Router {
    
    func close() {
        _view.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditTripRouter {
    var presenter: EditTripPresenter {
        return _presenter as! EditTripPresenter
    }
}
