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
        case .columns(let isCSV):
            openColumns(isCSV: isCSV)
        case .paymentMethods:
            openPaymentMethods()
        case .categories:
            openCategories()
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
    
    func openColumns(isCSV: Bool) {
        let module = AppModules.columns.build()
        module.presenter.setupView(data: isCSV)
        executeFor(iPhone: {
            module.router.show(from: _view)
        }, iPad: {
            module.router.showIPadForm(from: _view)
        })
    }
    
    func openPaymentMethods() {
        let module = AppModules.paymentMethods.build()
        executeFor(iPhone: {
            module.router.show(from: _view)
        }, iPad: {
            module.router.showIPadForm(from: _view)
        })
    }
    
    func openCategories() {
        let module = AppModules.categories.build()
        executeFor(iPhone: {
            module.router.show(from: _view)
        }, iPad: {
            module.router.showIPadForm(from: _view)
        })
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
    case columns(isCSV: Bool)
    case paymentMethods
    case categories
}
