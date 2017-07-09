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
    
    func openRoute(_ route: SettingsRoutes) {
        switch route {
        case .privacyPolicy:
            openPrivacyPolicy()
        case .sendLove:
            openSendLove()
        }
    }
    
    func close() {
        _view.dismiss(animated: true, completion: nil)
    }
    
    func openSendLove() {
        if let reviewUrl = URL(string: "itms-apps://itunes.apple.com/app/id\(SmartReceiptAppStoreId)") {
            if UIApplication.shared.canOpenURL(reviewUrl) {
                UIApplication.shared.openURL(reviewUrl)
            }
        }
    }
    
    func openPrivacyPolicy() {
        if let privacyPolicyURL = URL(string: "https://www.smartreceipts.co/privacy") {
            if UIApplication.shared.canOpenURL(privacyPolicyURL) {
                UIApplication.shared.openURL(privacyPolicyURL)
            }
        }
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension SettingsRouter {
    var presenter: SettingsPresenter {
        return _presenter as! SettingsPresenter
    }
}

enum SettingsRoutes {
    case sendLove
    case privacyPolicy
}
