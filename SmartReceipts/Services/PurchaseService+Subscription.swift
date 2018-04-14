//
//  PurchaseService+Subscription.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 10/04/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import RxSwift

typealias SubscriptionValidation = (valid: Bool, expireTime: Date?)

// Global Cached Validation
private var cachedValidation: SubscriptionValidation?

extension PurchaseService {
    
    func resetCache() {
        cachedValidation = nil
    }
    
    func cacheSubscriptionValidation() {
        validateSubscription().subscribe(onNext: { validation in
            Logger.debug("Cached Validation: Valid = \(validation.valid), expire: \(String(describing: validation.expireTime))")
        }, onError: { error in
            Logger.error(error.localizedDescription)
        }).disposed(by: bag)
    }
    
    func hasValidSubscriptionValue() -> Bool {
        guard let cached = cachedValidation else { return false }
        return cached.valid
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
        }).do(onNext: { cachedValidation = $0 })
    }
    
    func verifySubscription(receipt: ReceiptInfo) -> VerifySubscriptionResult {
        return SwiftyStoreKit.verifySubscription(ofType: .nonRenewing(validDuration: TimeInterval.year), productId: PRODUCT_PLUS, inReceipt: receipt)
    }
}
