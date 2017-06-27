//
//  TaxCalculator.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift

class TaxCalculator: NSObject {
    
    let priceSubject = PublishSubject<Decimal?>()
    let taxSubject = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    private var taxFormatter = NumberFormatter()
    private var priceIsPreTax = false
    private var taxPercentage = NSDecimalNumber(decimal: 0)
    
    fileprivate static let HUNDRED = NSDecimalNumber(decimal: 100)
    
    override init() {
        super.init()
        taxFormatter.numberStyle = .currency
        taxFormatter.currencySymbol = ""
        taxFormatter.currencyGroupingSeparator = ""
        priceIsPreTax = WBPreferences.enteredPricePreTax()
        taxPercentage = NSDecimalNumber(string: "\(WBPreferences.defaultTaxPercentage())")
        
        priceSubject.subscribe(onNext: { [unowned self] value in
            if let val = value {
                let price = NSDecimalNumber(decimal: val)
                let tax = TaxCalculator.taxWithPrice(price, taxPercentage: self.taxPercentage,
                                                               preTax: self.priceIsPreTax)
                self.taxSubject.onNext(self.taxFormatter.string(from: tax)!)
            } else {
                self.taxSubject.onNext("")
            }
        }).disposed(by: disposeBag)
    }
    
    class func taxWithPrice(_ price: NSDecimalNumber, taxPercentage: NSDecimalNumber, preTax: Bool = false) -> NSDecimalNumber {
        var tax = NSDecimalNumber()
        if preTax {
            tax = price.multiplying(by: taxPercentage).dividing(by: HUNDRED)
        } else {
            let addeage = HUNDRED.adding(taxPercentage)
            let divided = price.dividing(by: addeage)
            tax = divided.multiplying(by: taxPercentage)
        }
        return tax
        
    }
}
