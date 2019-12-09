//
//  EditReceiptRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class EditReceiptRouter: Router {
    
    func openSettings() {
        let settingsVC = MainStoryboard().instantiateViewController(withIdentifier: "SettingsOverflow")
        settingsVC.modalTransitionStyle = .coverVertical
        settingsVC.modalPresentationStyle = .formSheet
        _view.viewController.present(settingsVC, animated: true, completion: nil)
    }
    
    func close(){
        _view.viewController.dismiss(animated: true, completion: nil)
    }
    
    func openAuth() -> AuthModuleInterface {
        let module = AppModules.auth.build()
        openModal(module: module)
        return module.interface(AuthModuleInterface.self)
    }
    
    func openAutoScans() {
        let module = AppModules.OCRConfiguration.build()
        openModal(module: module)
    }
    
    func openPaymentMethods() {
        let module = AppModules.paymentMethods.build()
        module.router.show(from: _view.viewController)
    }
    
    func openCategories() {
        let module = AppModules.categories.build()
        module.router.show(from: _view.viewController)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditReceiptRouter {
    var presenter: EditReceiptPresenter {
        return _presenter as! EditReceiptPresenter
    }
}
