//
//  ReceiptsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class ReceiptsRouter: Router {
    
    var moduleTrip: WBTrip! = nil
    
    func openDistances() {
        let module = Module.build(AppModules.tripDistances)
        executeFor(iPhone: {
            module.router.show(from: _view, embedInNavController: true, setupData: moduleTrip)
        }, iPad: {
            module.router.showIPadForm(from: _view, setupData: moduleTrip, needNavigationController: true)
        })
    }
    
    func openGenerateReport() {
        let module = Module.build(AppModules.generateReport)
        executeFor(iPhone: {
            module.router.show(from: _view, embedInNavController: true, setupData: moduleTrip)
        }, iPad: {
            module.router.showIPadForm(from: _view, setupData: moduleTrip, needNavigationController: true)
        })
    }
    
    func openCreateReceipt() {
        openEditModuleWith(receipt: nil, image: nil)
    }
    
    func openCreatePhotoReceipt() {
    
    }
    
    func openActions(receipt: WBReceipt) -> ReceiptActionsPresenter {
        let module = Module.build(AppModules.receiptActions)
        executeFor(iPhone: {
            module.router.show(from: _view, embedInNavController: true, setupData: receipt)
        }, iPad: {
            module.router.showIPadForm(from: _view, setupData: receipt, needNavigationController: true)
        })
        return module.presenter as! ReceiptActionsPresenter
    }
    
    func openEdit(receipt: WBReceipt, image: UIImage? = nil) {
        openEditModuleWith(receipt: receipt, image: image)
    }
    
    private func openEditModuleWith(receipt: WBReceipt?, image: UIImage?) {
        let module = Module.build(AppModules.editReceipt)
        let data = (trip: moduleTrip, receipt: receipt, image: image)
        executeFor(iPhone: {
            module.router.show(from: _view, embedInNavController: true, setupData: data)
        }, iPad: {
            module.router.showIPadForm(from: _view, setupData: data, needNavigationController: true)
        })
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptsRouter {
    var presenter: ReceiptsPresenter {
        return _presenter as! ReceiptsPresenter
    }
}
