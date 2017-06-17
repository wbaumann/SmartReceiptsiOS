//
//  TaxCalculator.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

class TaxCalculator: NSObject {

    var priceIsPreTax = false
    var taxPercentage = NSDecimalNumber(decimal: 0)
    
    private var priceField: UITextField!
    private var taxField: UITextField!
    private var taxFormatter: NumberFormatter!
    
    fileprivate static let HUNDRED = NSDecimalNumber(decimal: 100)
    
    init(priceField: UITextField, taxField: UITextField) {
        super.init()
        self.priceField = priceField
        self.taxField = taxField
        
        priceField.addTarget(self, action: #selector(priceChanged), for: .editingChanged)
        
        taxFormatter = NumberFormatter()
        taxFormatter.numberStyle = .currency
        taxFormatter.currencySymbol = ""
        taxFormatter.currencyGroupingSeparator = ""
    }
    
    func priceChanged() {
        let priceString = priceField.text
        let price = NSDecimalNumber(orZeroUsingCurrentLocale: priceString)
        let tax = TaxCalculator.taxWithPrice(price!, taxPercentage: taxPercentage, preTax: priceIsPreTax)
        taxField.text = taxFormatter.string(from: tax)
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
