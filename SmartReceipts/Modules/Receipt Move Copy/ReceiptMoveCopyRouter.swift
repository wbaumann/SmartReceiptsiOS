//
//  ReceiptMoveCopyRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 22/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class ReceiptMoveCopyRouter: Router {
    func close() {
        _view.viewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptMoveCopyRouter {
    var presenter: ReceiptMoveCopyPresenter {
        return _presenter as! ReceiptMoveCopyPresenter
    }
}
