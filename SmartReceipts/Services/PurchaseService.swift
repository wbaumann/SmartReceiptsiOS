//
//  PurchaseService.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 02/10/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RMStore
import RxSwift
import StoreKit

let PRODUCT_OCR_10 = "ios_ocr_purchase_10"
let PRODUCT_OCR_50 = "ios_ocr_purchase_50"
let PRODUCT_PLUS = "ios_plus_sku_2"

class PurchaseService {
    private var plusSubsribtionProduct: SKProduct?
    private let bag = DisposeBag()
    
    func requestProducts() -> Observable<SKProduct> {
        let ids: Set = [PRODUCT_PLUS, PRODUCT_OCR_10, PRODUCT_OCR_50]
        return RMStore.default().requestProducts(identifiers: ids)
            .do(onError: { error in
                let errorEvent = ErrorEvent(error: error)
                AnalyticsManager.sharedManager.record(event: errorEvent)
            })
    }
    
    func restorePurchases() -> Observable<Void> {
        return RMStore.default().restorePurchases()
            .do(onNext: {
                NotificationCenter.default.post(name: NSNotification.Name.SmartReceiptsAdsRemoved, object: nil)
            }, onError: handleError(_:))
    }
    
    func purchaseSubscription() -> Observable<SKPaymentTransaction> {
        AnalyticsManager.sharedManager.record(event: Event.Navigation.SmartReceiptsPlusOverflow)
        return RMStore.default().addPayment(product: PRODUCT_PLUS)
            .do(onNext: { transaction in
                PurchaseService.analyticsPurchaseSuccess(productID: PRODUCT_PLUS)
                NotificationCenter.default.post(name: NSNotification.Name.SmartReceiptsAdsRemoved, object: nil)
            }, onError: { [weak self] error in
                PurchaseService.analyticsPurchaseFailed(productID: PRODUCT_PLUS)
                self?.handleError(error)
            })
    }
    
    private func handleError(_ error: Error) {
        let responseError = error as NSError
        if responseError.code == SKError.paymentCancelled.rawValue && responseError.domain == SKErrorDomain {
            Logger.warning("Cancelled by User")
            return
        } else {
            Logger.warning("Unknown error")
            let errorEvent = ErrorEvent(error: responseError)
            AnalyticsManager.sharedManager.record(event: errorEvent)
        }
    }
    
    private static func analyticsPurchaseSuccess(productID: String) {
        let anEvent =  Event.Purchases.PurchaseSuccess
        anEvent.dataPoints.append(DataPoint(name: "sku", value: productID))
        AnalyticsManager.sharedManager.record(event: anEvent)
    }
    
    private static func analyticsPurchaseFailed(productID: String) {
        let anEvent =  Event.Purchases.PurchaseFailed
        anEvent.dataPoints.append(DataPoint(name: "sku", value: productID))
        AnalyticsManager.sharedManager.record(event: anEvent)
    }
    
}
