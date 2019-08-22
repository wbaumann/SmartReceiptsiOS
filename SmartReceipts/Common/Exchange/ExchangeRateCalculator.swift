//
//  ExchangeRateCalculator.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 19/07/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift

class ExchangeRateCalculator {
    let exchangeRateUpdate = PublishSubject<Double>()
    let baseCurrencyPriceUpdate = PublishSubject<Double>()
    private let bag = DisposeBag()
    
    init(price: Double = 0, exchangeRate: Double = 0) {
        self.price = price
        self.exchangeRate = exchangeRate
    }
    
    var price: Double = 0 {
        didSet {
            let result = price*exchangeRate
            baseCurrencyPriceUpdate.onNext(result)
        }
    }
    
    var exchangeRate: Double = 0 {
        didSet {
            let result = price*exchangeRate
            baseCurrencyPriceUpdate.onNext(result)
        }
    }
    
    var baseCurrencyPrice: Double = 0 {
        didSet {
            if price == 0 { return }
            let result = baseCurrencyPrice/price
            exchangeRateUpdate.onNext(result)
        }
    }
}
