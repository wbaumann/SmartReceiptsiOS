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
    
    private var plusSubsribtionProduct: SKProduct?
    
    func retrivePlusSubscriptionPrice() -> Observable<String> {
        return Observable<String>.create({ observer -> Disposable in
            RMStore.default().requestProducts([SmartReceiptSubscriptionIAPIdentifier],
                      success: { [unowned self] products, _ in
                let formatter = NumberFormatter()
                formatter.formatterBehavior = .behavior10_4
                formatter.numberStyle = .currency
                for product in products as! [SKProduct] {
                    if product.productIdentifier == SmartReceiptSubscriptionIAPIdentifier {
                        formatter.locale = product.priceLocale
                        let price = "\(formatter.string(from: product.price)!)/yr"
                        self.plusSubsribtionProduct = product
                        observer.onNext(price)
                    }
                }
            }, failure: { error in
                if let responseError = error {
                    let errorEvent = ErrorEvent(error: responseError)
                    AnalyticsManager.sharedManager.record(event: errorEvent)
                    observer.onError(responseError)
                }
            })
            
            return Disposables.create()
        })
    }
    
    func restorePurchases() -> Observable<Void> {
        return Observable<Void>.create({ observer -> Disposable in
            RMStore.default().refreshReceipt(onSuccess: {
                observer.onNext()
                NotificationCenter.default.post(name: NSNotification.Name.SmartReceiptsAdsRemoved, object: nil)
            }, failure: { error in
                if let responseError = error as NSError? {
                    if responseError.code == SKError.paymentCancelled.rawValue && responseError.domain == SKErrorDomain {
                        Logger.warning("Cancelled by User")
                        return
                    } else {
                        Logger.warning("Unknown error")
                        let errorEvent = ErrorEvent(error: responseError)
                        AnalyticsManager.sharedManager.record(event: errorEvent)
                    }
                    observer.onError(responseError)
                }
            })
            return Disposables.create()
        })
    }
    
    func purchaseSubscription() -> Observable<Void> {
        AnalyticsManager.sharedManager.record(event: Event.Navigation.SmartReceiptsPlusOverflow)
        
        return Observable<Void>.create({ [unowned self] observer -> Disposable in
            RMStore.default().addPayment(self.plusSubsribtionProduct?.productIdentifier,
                                      success: { [unowned self] transaction in
                self.analyticsPurchaseSuccess(productID: transaction!.payment.productIdentifier)
                observer.onNext()
                NotificationCenter.default.post(name: NSNotification.Name.SmartReceiptsAdsRemoved, object: nil)
            }, failure: { [unowned self] tranaction, error in
                if let responseError = error as NSError? {
                    self.analyticsPurchaseFailed(productID: tranaction!.payment.productIdentifier)
                    if responseError.code == SKError.paymentCancelled.rawValue && responseError.domain == SKErrorDomain {
                        Logger.warning("Cancelled by User")
                        return
                    } else {
                        Logger.warning("Unknown error")
                        let errorEvent = ErrorEvent(error: responseError)
                        AnalyticsManager.sharedManager.record(event: errorEvent)
                    }
                    observer.onError(responseError)
                }

            })
            
            return Disposables.create()
        })
    }
  
    private func analyticsPurchaseSuccess(productID: String) {
        let anEvent =  Event.Purchases.PurchaseSuccess
        anEvent.dataPoints.append(DataPoint(name: "sku", value: productID))
        AnalyticsManager.sharedManager.record(event: anEvent)
    }
    
    private func analyticsPurchaseFailed(productID: String) {
        let anEvent =  Event.Purchases.PurchaseSuccess
        anEvent.dataPoints.append(DataPoint(name: "sku", value: productID))
        AnalyticsManager.sharedManager.record(event: anEvent)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension SettingsInteractor {
    var presenter: SettingsPresenter {
        return _presenter as! SettingsPresenter
    }
}
