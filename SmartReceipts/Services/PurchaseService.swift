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
import SwiftyJSON

let PRODUCT_OCR_10 = "ios_ocr_purchase_10"
let PRODUCT_OCR_50 = "ios_ocr_purchase_50"
let PRODUCT_PLUS = "ios_plus_sku_2"

class PurchaseService {
    private var plusSubsribtionProduct: SKProduct?
    fileprivate let bag = DisposeBag()
    
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
        return purchase(prodcutID: PRODUCT_PLUS)
            .do(onNext: { _ in
                NotificationCenter.default.post(name: NSNotification.Name.SmartReceiptsAdsRemoved, object: nil)
            }, onError: handleError(_:))
    }
    
    func purchase(prodcutID: String) -> Observable<SKPaymentTransaction> {
        return RMStore.default().addPayment(product: prodcutID)
            .do(onNext: { [weak self] transaction in
                PurchaseService.analyticsPurchaseSuccess(productID: prodcutID)
                self?.sendConfirm(transaction: transaction)
            }, onError: { _ in
                PurchaseService.analyticsPurchaseFailed(productID: prodcutID)
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
}


// MARK: Purchase and API
extension PurchaseService {
    func sendConfirm(transaction: SKPaymentTransaction) {
        if AuthService.shared.isLoggedIn {
            guard let receiptURL = Bundle.main.appStoreReceiptURL else { return }
            guard let receipt = try? Data(contentsOf: receiptURL) else { return }
            let receiptString = receipt.base64EncodedString()
            Logger.debug("RECEIPT: \(receiptString)")
            let params = ["encoded_receipt": receiptString,
                          "pay_service" : "Apple Store",
                          "goal" : "Recognition"]
            
            APIAdapter.jsonBody(.post, endpoint("mobile_app_purchases"), parameters: params)
                .subscribe(onNext: { response in
                    let jsonRespose = JSON(response)
                    Logger.debug(jsonRespose.description)
                }, onError: { error in
                    Logger.error(error.localizedDescription)
                }).disposed(by: bag)
        }
    }
}


// MARK: Purchase Analytics
extension PurchaseService {
    fileprivate static func analyticsPurchaseSuccess(productID: String) {
        let anEvent =  Event.Purchases.PurchaseSuccess
        anEvent.dataPoints.append(DataPoint(name: "sku", value: productID))
        AnalyticsManager.sharedManager.record(event: anEvent)
    }
    
    fileprivate static func analyticsPurchaseFailed(productID: String) {
        let anEvent =  Event.Purchases.PurchaseFailed
        anEvent.dataPoints.append(DataPoint(name: "sku", value: productID))
        AnalyticsManager.sharedManager.record(event: anEvent)
    }
}
