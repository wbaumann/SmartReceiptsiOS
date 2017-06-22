//
//  ReceiptActionsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class ReceiptActionsRouter: Router {
    
    func close() {
        _view.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptActionsRouter {
    var presenter: ReceiptActionsPresenter {
        return _presenter as! ReceiptActionsPresenter
    }
}
