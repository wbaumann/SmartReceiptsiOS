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
        _view.present(settingsVC, animated: true, completion: nil)
    }
    
    func close(){
        _view.dismiss(animated: true, completion: nil)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditReceiptRouter {
    var presenter: EditReceiptPresenter {
        return _presenter as! EditReceiptPresenter
    }
}
