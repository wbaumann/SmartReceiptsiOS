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
    
    func openMove(receipt: WBReceipt) {
        openMoveCopy(receipt: receipt, copyOrMove: false)
    }
    
    func openCopy(receipt: WBReceipt) {
        openMoveCopy(receipt: receipt, copyOrMove: true)
    }
    
    private func openMoveCopy(receipt: WBReceipt, copyOrMove: Bool) {
        let module = Module.build(AppModules.receiptMoveCopy)
        module.presenter.setupView(data: (receipt, copyOrMove))
        executeFor(iPhone: {
            module.router.show(from: _view, embedInNavController: false)
        }, iPad: {
            showIPadForm(from: _view)
        })
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptActionsRouter {
    var presenter: ReceiptActionsPresenter {
        return _presenter as! ReceiptActionsPresenter
    }
}
