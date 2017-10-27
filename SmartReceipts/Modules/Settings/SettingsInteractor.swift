//
//  SettingsInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import StoreKit
import RxSwift
import RMStore

class SettingsInteractor: Interactor {
    private let purchaseService = PurchaseService()
    
    func retrivePlusSubscriptionPrice() -> Observable<String> {
        return purchaseService.price(productID: PRODUCT_PLUS)
            .map({ "\($0)/yr" })
    }
    
    func restorePurchases() -> Observable<Void> {
        return purchaseService.restorePurchases()
    }
    
    func purchaseSubscription() -> Observable<Void> {
        AnalyticsManager.sharedManager.record(event: Event.Navigation.SmartReceiptsPlusOverflow)
        return purchaseService.purchaseSubscription().map({ _ -> Void in })
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension SettingsInteractor {
    var presenter: SettingsPresenter {
        return _presenter as! SettingsPresenter
    }
}
