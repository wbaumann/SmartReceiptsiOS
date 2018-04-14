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

class SettingsInteractor: Interactor {
    private let purchaseService = PurchaseService()
    
    func retrivePlusSubscriptionPrice() -> Observable<String> {
        return purchaseService.price(productID: PRODUCT_PLUS)
            .map({ "\($0)/yr" })
    }
    
    func restoreSubscription() -> Observable<SubscriptionValidation> {
        purchaseService.resetCache()
        return purchaseService.validateSubscription()
            .do(onNext: { validation in
                if validation.valid {
                    NotificationCenter.default.post(name: NSNotification.Name.SmartReceiptsAdsRemoved, object: nil)
                }
            })
    }
    
    func purchaseSubscription() -> Observable<Void> {
        AnalyticsManager.sharedManager.record(event: Event.Navigation.SmartReceiptsPlusOverflow)
        return purchaseService.purchaseSubscription().map({ _ -> Void in })
    }
    
    func subscriptionValidation() -> Observable<SubscriptionValidation> {
        return purchaseService.validateSubscription()
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension SettingsInteractor {
    var presenter: SettingsPresenter {
        return _presenter as! SettingsPresenter
    }
}
