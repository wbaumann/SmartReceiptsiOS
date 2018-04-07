//
//  PurchaseService.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 02/10/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import StoreKit
import SwiftyJSON

let PRODUCT_OCR_10 = "ios_ocr_purchase_10"
let PRODUCT_OCR_50 = "ios_ocr_purchase_50"
let PRODUCT_PLUS = "ios_plus_sku_2"

class PurchaseService {
    private var plusSubsribtionProduct: SKProduct?
    fileprivate let bag = DisposeBag()
    static fileprivate var cachedProducts = [SKProduct]()
    
    func cacheProducts() {
        requestProducts().toArray()
        .do(onNext: { products in
            Logger.debug("Available purchases: \(products)")
        }).subscribe(onNext: { products in
            PurchaseService.cachedProducts = products
        }).disposed(by: bag)
    }
    
    func requestProducts() -> Observable<SKProduct> {
        let ids: Set = [PRODUCT_PLUS, PRODUCT_OCR_10, PRODUCT_OCR_50]
        return Observable<SKProduct>.never()
//        return RMStore.default().requestProducts(identifiers: ids)
//            .do(onError: { error in
//                let errorEvent = ErrorEvent(error: error)
//                AnalyticsManager.sharedManager.record(event: errorEvent)
//            })
    }
    
    func restorePurchases() -> Observable<Void> {
        return Observable<Void>.never()
//        return RMStore.default().restorePurchases()
//            .do(onNext: {
//                Logger.debug("Successful restore purchases")
//                NotificationCenter.default.post(name: NSNotification.Name.SmartReceiptsAdsRemoved, object: nil)
//            }, onError: handleError(_:))
    }
    
    func purchaseSubscription() -> Observable<SKPaymentTransaction> {
        return purchase(prodcutID: PRODUCT_PLUS)
            .do(onNext: { _ in
                Logger.debug("Successful restore PLUS Subscription")
                NotificationCenter.default.post(name: NSNotification.Name.SmartReceiptsAdsRemoved, object: nil)
            }, onError: handleError(_:))
    }
    
    func purchase(prodcutID: String) -> Observable<SKPaymentTransaction> {
        return Observable<SKPaymentTransaction>.never()
//        return (isCachedProduct(id: prodcutID) ? Observable<Void>.just(()) : requestProducts().toArray().map({ _ in }))
//            .flatMap({ _ in
//                RMStore.default().addPayment(product: prodcutID)
//            .do(onNext: { [weak self] _ in
//                Logger.debug("Successful purchase: \(prodcutID)")
//                PurchaseService.analyticsPurchaseSuccess(productID: prodcutID)
//                self?.sendReceipt()
//            }, onError: { _ in
//                Logger.error("Failed purchase: \(prodcutID)")
//                PurchaseService.analyticsPurchaseFailed(productID: prodcutID)
//            })
//        })
    }
    
    func price(productID: String) -> Observable<String> {
        return requestProducts()
            .filter({ $0.productIdentifier == productID })
            .map({ $0.localizedPrice })
    }
    
    private func handleError(_ error: Error) {
        let responseError = error as NSError
        if responseError.code == SKError.paymentCancelled.rawValue && responseError.domain == SKErrorDomain {
            Logger.error("Cancelled by User")
            return
        } else {
            Logger.error("Unknown error: \(error.localizedDescription)")
            let errorEvent = ErrorEvent(error: responseError)
            AnalyticsManager.sharedManager.record(event: errorEvent)
        }
    }
    
    private func isCachedProduct(id: String) -> Bool {
        for product in PurchaseService.cachedProducts {
            if product.productIdentifier == id { return true }
        }
        return false
    }
    
    func appStoreReceipt() -> String? {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else { return nil }
        guard let receipt = try? Data(contentsOf: receiptURL) else { return nil }
        return receipt.base64EncodedString()
    }
    
    func isReceiptSent(_ receipt: String) -> Bool {
        return UserDefaults.standard.bool(forKey: receipt)
    }
    
    // MARK: Purchase and API
    
    func sendReceipt() {
        if !AuthService.shared.isLoggedIn {
            Logger.warning("Can't send receipt: User are not logged in!")
            return
        }
        guard let receiptString = appStoreReceipt() else { return }
        if isReceiptSent(receiptString) {
            Logger.warning("Can't send receipt: Receipt is sent before")
            return
        }
    
        let params = ["encoded_receipt" : receiptString,
                      "pay_service"     : "Apple Store",
                      "goal"            : "Recognition"]
        
        APIAdapter.jsonBody(.post, endpoint("mobile_app_purchases"), parameters: params)
            .retry(3)
            .do(onNext: { _ in
                UserDefaults.standard.set(true, forKey: receiptString)
                Logger.debug("Cached receipt: \(receiptString)")
            }).do(onError: { _ in
                UserDefaults.standard.set(false, forKey: receiptString)
                Logger.error("Can't cache receipt: \(receiptString)")
            }).flatMap({ response -> Observable<Any> in
                return ScansPurchaseTracker.shared.fetchAndPersistAvailableRecognitions()
                    .map({ _ -> Any in return response })
            }).subscribe(onNext: { response in
                let jsonRespose = JSON(response)
                Logger.debug(jsonRespose.description)
            }, onError: { error in
                Logger.error(error.localizedDescription)
            }).disposed(by: bag)
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

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)!
    }
}
