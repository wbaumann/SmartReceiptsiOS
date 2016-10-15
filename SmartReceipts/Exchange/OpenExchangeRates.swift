//
//  OpenExchangeRates.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

private let OpenEchangeRatesAPIHistorycalAddress = "https://openexchangerates.org/api/historical/"

class OpenExchangeRates {
    static let sharedInstance = OpenExchangeRates()
    private var rates = [String: [ExchangeRate]]()
    
    func exchangeRate(base: String, target: String, onDate date: NSDate, forceRefresh: Bool, completion: (NSDecimalNumber?, NSError?) -> ()) {
        let dayString = date.dayString()
        let dayCurrencyKey = "\(dayString)-\(base)"
        
        Log.debug("Retrieve \(base) to \(target) on \(dayString)")
        
        if !forceRefresh, let dayValues = rates[dayCurrencyKey], let rate = dayValues.filter({ $0.currency == target}).first {
            Log.debug("Have cache hit")
            completion(rate.rate, nil)
            return
        } else if (forceRefresh) {
            Log.debug("Refresh forced")
        }
        
        Log.debug("Perform remote fetch")
        let requestURL = NSURL(string: "\(OpenEchangeRatesAPIHistorycalAddress)\(dayString).json?base=\(base)&app_id=\(OpenExchangeAppID)")!
        Log.debug("\(requestURL)")
        let request = NSURLRequest(URL: requestURL)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            Log.debug("Request completed")
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard var rates = ExchangeRate.loadFromData(data!) else {
                completion(nil, nil)
                return
            }
            
            if let rate = rates.filter({ $0.currency == target }).first {
                completion(rate.rate, nil)
            } else {
                // add unsupported currency marker
                rates.append(ExchangeRate(currency: target, rate: .minusOne()))
                completion(.minusOne(), nil)
            }
            self.rates[dayCurrencyKey] = rates
        }
        
        task.resume()
    }
}
