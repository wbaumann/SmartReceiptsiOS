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
    var taxPercentage = NSDecimalNumber(decimal: 0)
    
    private let disposeBag = DisposeBag()
    private var priceIsPreTax = false
    private let formatter = NumberFormatter()
    
    fileprivate static let HUNDRED = NSDecimalNumber(decimal: 100)
    
    init(preTax: Bool) {
        super.init()
        priceIsPreTax = preTax
        taxPercentage = NSDecimalNumber(string: "\(WBPreferences.defaultTaxPercentage())")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        
        priceSubject.subscribe(onNext: { [unowned self] value in
            if let val = value {
                let price = NSDecimalNumber(decimal: val)
                let tax = TaxCalculator.taxWithPrice(price, taxPercentage: self.taxPercentage, preTax: self.priceIsPreTax)
                self.taxSubject.onNext(self.formatter.string(from: tax)!)
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
