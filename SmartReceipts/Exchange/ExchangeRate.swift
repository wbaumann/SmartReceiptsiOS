//
//  ExchangeRate.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

struct ExchangeRate {
    let currency: String
    let rate: NSDecimalNumber
    
    static func loadFromData(data: NSData) -> [ExchangeRate]? {
        guard let content = ExchangeRate.content(data) else {
            return nil
        }
        
        guard let rates = content["rates"] as? [String: NSNumber] else {
            return nil
        }
        
        var result = [ExchangeRate]()
        for (currency, value) in rates {
            // We are using trip currency as base. Need to calculate reverse rate from receipt currency to trip currency.
            
            let forward = value.decimalNumber()
            let reverse = NSDecimalNumber.one().decimalNumberByDividingBy(forward)
            
            let exchange = ExchangeRate(currency: currency, rate: reverse)
            result.append(exchange)
        }
        
        return result
    }
    
    private static func content(data: NSData) -> [String: AnyObject]? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
        } catch let error as NSError {
            Log.debug("JSON parse error \(error)")
            return nil
        }
    }
}