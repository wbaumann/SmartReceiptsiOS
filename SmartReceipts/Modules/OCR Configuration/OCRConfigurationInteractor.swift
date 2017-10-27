//
//  OCRConfigurationInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/10/2017.
//Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import StoreKit

class OCRConfigurationInteractor: Interactor {
    let purchaseService = PurchaseService()
    
    func requestProducts() -> Observable<SKProduct> {
        return purchaseService.requestProducts()
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension OCRConfigurationInteractor {
    var presenter: OCRConfigurationPresenter {
        return _presenter as! OCRConfigurationPresenter
    }
}
