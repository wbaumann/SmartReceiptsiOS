//
//  PurchaseService.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 02/10/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import StoreKit
import Moya
import SwiftyStoreKit

let PRODUCT_OCR_10 = "ios_ocr_purchase_10"
let PRODUCT_OCR_50 = "ios_ocr_purchase_50"
let PRODUCT_PLUS = "ios_plus_sku_2"

fileprivate let APPSTORE_INTERACTED = "appstore_interacted"
fileprivate let CACHED_VALIDATION_EXPIRE = "cached_validation_expireTime"

typealias SubscriptionValidation = (valid: Bool, expireTime: Date?)

// Global Cached Validation
private var cachedValidation: SubscriptionValidation?

class PurchaseService {
    private let apiProvider: APIProvider<SmartReceiptsAPI>
    private let authService: AuthServiceInterface
    private var plusSubsribtionProduct: SKProduct?
    static fileprivate var cachedProducts = [SKProduct]()
    let bag = DisposeBag()
    
    init(apiProvider: APIProvider<SmartReceiptsAPI> = .init(), authService: AuthServiceInterface = AuthService.shared) {
        self.apiProvider = apiProvider
        self.authService = authService
        
        let expire = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: CACHED_VALIDATION_EXPIRE))
        let valid = expire > Date()
        if valid { cache(validation: (valid, expire)) }
        
        authService.loggedInObservable
            .filter({ $0 && !PurchaseService.hasValidSubscriptionValue })
            .flatMap({ _ in
                return apiProvider.request(.subscriptions).mapModel(SubscriptionsResponse.self)
            }).map({ response -> SubscriptionModel? in
                return response.subscriptions.sorted(by: { $0.expiresAt > $1.expiresAt }).first
            }).filter({ $0 != nil })
            .map({ SubscriptionValidation($0!.expiresAt > Date(), $0!.expiresAt) })
            .map({ validation -> SubscriptionValidation in
                guard let cachedExpireTime = cachedValidation?.expireTime else { return validation }
                return validation.expireTime! > cachedExpireTime ? validation : cachedValidation!
            })
            .filter({ $0.valid })
            .do(onNext: { [weak self] validation in self?.cache(validation: validation) })
            .do(onError: { error in
                Logger.error(error.localizedDescription)
            }).subscribe(onNext: { [weak self] validation in
                self?.cache(validation: validation)
                NotificationCenter.default.post(name: .SmartReceiptsAdsRemoved, object: nil)
            }).disposed(by: bag)
    }
    
    private func cache(validation: SubscriptionValidation) {
        cachedValidation = validation
        guard let interval = validation.expireTime?.timeIntervalSince1970 else { return }
        UserDefaults.standard.set(interval, forKey: CACHED_VALIDATION_EXPIRE)
    }
    
    class var hasValidSubscriptionValue: Bool {
        return DebugStates.isDebug && DebugStates.subscription() ? true : cachedValidation?.valid == true
    }
    
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
        return Observable<SKProduct>.create({ observer -> Disposable in
            SwiftyStoreKit.retrieveProductsInfo(ids) { result in
                result.retrievedProducts.forEach({ observer.onNext($0) })
            }
            return Disposables.create()
        }).do(onError: { error in
            let errorEvent = ErrorEvent(error: error)
            AnalyticsManager.sharedManager.record(event: errorEvent)
        })
    }
    
    func getSubscriptions() -> Single<[SubscriptionModel]> {
        return apiProvider.request(.subscriptions)
            .mapModel(SubscriptionsResponse.self)
            .map { $0.subscriptions }
    }
    
    func restorePurchases() -> Observable<[Purchase]> {
        return Observable<[Purchase]>.create({ observable -> Disposable in
            SwiftyStoreKit.restorePurchases(atomically: true) { results in
                if !results.restoredPurchases.isEmpty {
                    Logger.debug("Restore Success: \(results.restoredPurchases)")
                    observable.onNext(results.restoredPurchases)
                } else if !results.restoreFailedPurchases.isEmpty {
                    Logger.debug("Restore Failed: \(results.restoreFailedPurchases)")
                    observable.onError(results.restoreFailedPurchases.first!.0)
                } else {
                    Logger.debug("Nothing to Restore")
                    observable.onNext([])
                }
            }
            return Disposables.create()
        }).do(onNext: { [weak self] _ in
            self?.markAppStoreInteracted()
        })
    }
    
    func restoreSubscription() -> Observable<Bool> {
        return restorePurchases()
            .map({ purchases -> Bool in
                return purchases.contains(where: { $0.productId == PRODUCT_PLUS })
            }).do(onNext: { [weak self] restored in
                self?.markAppStoreInteracted()
                if restored {
                    Logger.debug("Successfuly restored Subscription")
                    NotificationCenter.default.post(name: .SmartReceiptsAdsRemoved, object: nil)
                }
            })
    }
    
    func purchaseSubscription() -> Observable<PurchaseDetails> {
        return purchase(prodcutID: PRODUCT_PLUS)
            .do(onNext: { [weak self] _ in
                self?.markAppStoreInteracted()
                self?.resetCache()
                Logger.debug("Successful restore PLUS Subscription")
                NotificationCenter.default.post(name: .SmartReceiptsAdsRemoved, object: nil)
            }, onError: handleError(_:))
    }
    
    func purchase(prodcutID: String) -> Observable<PurchaseDetails> {
        return Observable<PurchaseDetails>.create({ observer -> Disposable in
            SwiftyStoreKit.purchaseProduct(prodcutID, atomically: true) { result in
                switch result {
                case .success(let purchase):
                    Logger.debug("Purchase Success: \(purchase.productId)")
                    observer.onNext(purchase)
                case .error(let error):
                    switch error.code {
                    case .unknown: Logger.error("Unknown error. Please contact support")
                    case .clientInvalid: Logger.error("Not allowed to make the payment")
                    case .paymentCancelled: break
                    case .paymentInvalid: Logger.error("The purchase identifier was invalid")
                    case .paymentNotAllowed: Logger.error("The device is not allowed to make the payment")
                    case .storeProductNotAvailable: Logger.error("The product is not available in the current storefront")
                    case .cloudServicePermissionDenied: Logger.error("Access to cloud service information is not allowed")
                    case .cloudServiceNetworkConnectionFailed: Logger.error("Could not connect to the network")
                    case .cloudServiceRevoked: Logger.error("User has revoked permission to use this cloud service")
                    default: Logger.error(error.localizedDescription)
                    }
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }).do(onNext: { [weak self] _ in
            Logger.debug("Successful purchase: \(prodcutID)")
            PurchaseService.analyticsPurchaseSuccess(productID: prodcutID)
            self?.sendReceipt()
        }, onError: { _ in
            Logger.error("Failed purchase: \(prodcutID)")
            PurchaseService.analyticsPurchaseFailed(productID: prodcutID)
        })
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
    
    func completeTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: false) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.productId == PRODUCT_PLUS {
                        NotificationCenter.default.post(name: .SmartReceiptsAdsRemoved, object: nil)
                    }
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
    }
    
    func appStoreReceipt() -> String? {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else { return nil }
        guard let receipt = try? Data(contentsOf: receiptURL) else { return nil }
        return receipt.base64EncodedString()
    }
    
    func isReceiptSent(_ receipt: String) -> Bool {
        return UserDefaults.standard.bool(forKey: receipt)
    }
    
    func logPurchases() {
        if !isAppStoreInteracted() { return }
        
        let service: AppleReceiptValidator.VerifyReceiptURLType = DebugStates.isDebug ? .sandbox : .production
        let validator = AppleReceiptValidator(service: service, sharedSecret: nil)
        SwiftyStoreKit.verifyReceipt(using: validator) { [weak self] receiptResult in
            switch receiptResult {
            case .success(let receipt):
                guard let purchaseResult = self?.verifySubscription(receipt: receipt) else { return }
                Logger.debug("=== Purchases info ===")
                switch purchaseResult {
                case .purchased(_, let items):
                    self?.logReceiptItems(items)
                case .expired(_, let items):
                    self?.logReceiptItems(items)
                case .notPurchased: break
                }
                Logger.debug("======================")
            case .error(let error):
                Logger.error(error.localizedDescription)
            }
        }
    }
    
    private func logReceiptItems(_ items: [ReceiptItem]) {
        for item in items {
            Logger.debug("===== Purchase Item: \(item.productId) ====")
            Logger.debug("Purchase: \(item.purchaseDate)")
            Logger.debug("Original purchase: \(item.originalPurchaseDate)")
            guard let expire = item.subscriptionExpirationDate else { continue }
            Logger.debug("Expire: \(expire)")
        }
    }
    
    // MARK: - Purchase and API
    
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
    
        apiProvider.request(.mobileAppPurchases(receipt: receiptString))
            .retry(3)
            .do(onSuccess: { _ in
                UserDefaults.standard.set(true, forKey: receiptString)
                Logger.debug("Cached receipt: \(receiptString)")
            }).do(onError: { _ in
                UserDefaults.standard.set(false, forKey: receiptString)
                Logger.error("Can't cache receipt: \(receiptString)")
            }).flatMap({ response -> Single<Response> in
                return ScansPurchaseTracker.shared.fetchAndPersistAvailableRecognitions().map({ _ in response })
            }).mapString()
            .subscribe(onSuccess: { response in
                Logger.debug(response)
            }, onError: { error in
                Logger.error(error.localizedDescription)
            }).disposed(by: bag)
    }
    
    
    //MARK: - PurchaseService and Subscription
    
    func resetCache() {
        cachedValidation = nil
        UserDefaults.standard.set(0, forKey: CACHED_VALIDATION_EXPIRE)
    }
    
    func cacheSubscriptionValidation() {
        validateSubscription()
            .do(onNext: { [weak self] in self?.cache(validation: $0) })
            .subscribe(onNext: { validation in
                Logger.debug("Cached Validation: Valid = \(validation.valid), expire: \(String(describing: validation.expireTime))")
            }, onError: { error in
                Logger.error(error.localizedDescription)
            }).disposed(by: bag)
    }
    
    func hasValidSubscription() -> Observable<Bool> {
        return validateSubscription().map({ validation -> Bool in
            return validation.valid
        })
    }
    
    func subscriptionExpirationDate() -> Observable<Date?> {
        return validateSubscription().map({ validation -> Date? in
            return validation.expireTime
        })
    }
    
    func validateSubscription() -> Observable<SubscriptionValidation> {
        if cachedValidation?.valid == true { return .just(cachedValidation!) }
        if !isAppStoreInteracted() { return .just((false, nil)) }
        return forceValidateSubscription()
    }
    
    func forceValidateSubscription() -> Observable<SubscriptionValidation> {
        if DebugStates.subscription() {
            return Observable<SubscriptionValidation>.just((true, Date.distantFuture))
        } else if let validation = cachedValidation {
            return Observable<SubscriptionValidation>.just(validation)
        }
        
        return Observable<SubscriptionValidation>.create({ [weak self] observable -> Disposable in
            let service: AppleReceiptValidator.VerifyReceiptURLType = DebugStates.isDebug ? .sandbox : .production
            let validator = AppleReceiptValidator(service: service, sharedSecret: nil)
            SwiftyStoreKit.verifyReceipt(using: validator) { receiptResult in
                switch receiptResult {
                case .success(let receipt):
                    self?.markAppStoreInteracted()
                    guard let purchaseResult = self?.verifySubscription(receipt: receipt) else { return }
                    switch purchaseResult {
                    case .purchased(let expiryDate, _):
                        observable.onNext((true, expiryDate))
                    case .expired(let expiryDate, _):
                        observable.onNext((false, expiryDate))
                    case .notPurchased:
                        observable.onNext((false, nil))
                    }
                    
                case .error(let error):
                    observable.onError(error)
                }
                observable.onCompleted()
            }
            return Disposables.create()
        }).catchError({ error -> Observable<SubscriptionValidation> in
            return Observable<SubscriptionValidation>.just((false, nil))
        }).do(onNext: { [weak self] in self?.cache(validation: $0) })
    }
    
    func verifySubscription(receipt: ReceiptInfo) -> VerifySubscriptionResult {
        return SwiftyStoreKit.verifySubscription(ofType: .nonRenewing(validDuration: .year), productId: PRODUCT_PLUS, inReceipt: receipt)
    }
    
    func markAppStoreInteracted() {
        UserDefaults.standard.set(true, forKey: APPSTORE_INTERACTED)
    }
    
    func isAppStoreInteracted() -> Bool {
        return UserDefaults.standard.bool(forKey: APPSTORE_INTERACTED)
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
