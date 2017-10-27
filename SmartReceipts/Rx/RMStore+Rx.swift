//
//  RMStore+Rx.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 02/10/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RMStore
import RxSwift
import StoreKit

extension RMStore {
    func requestProducts(identifiers: Set<String>) -> Observable<SKProduct> {
        return Observable<SKProduct>.create({ observer -> Disposable in
            RMStore.default().requestProducts(identifiers, success: { products, _ in
                (products as! [SKProduct]).forEach({ observer.onNext($0) })
                observer.onCompleted()
            }, failure: { observer.onError($0!) })
            return Disposables.create()
        })
    }
    
    func restorePurchases() -> Observable<Void> {
        return Observable<Void>.create({ observer -> Disposable in
            RMStore.default().refreshReceipt(onSuccess: {
                observer.onNext()
                observer.onCompleted()
            }, failure: { observer.onError($0!) })
            return Disposables.create()
        })
    }
    
    func addPayment(product identifier: String) -> Observable<SKPaymentTransaction> {
        return Observable<SKPaymentTransaction>.create({ observer -> Disposable in
            RMStore.default().addPayment(identifier, success: { transaction in
                observer.onNext(transaction!)
                observer.onCompleted()
            }, failure: { transaction, error in
                observer.onError(error!)
            })
            return Disposables.create()
        })
    }
}
