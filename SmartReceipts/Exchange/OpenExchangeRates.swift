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
    fileprivate var rates = [String: [ExchangeRate]]()
    
    func exchangeRate(_ base: String, target: String, onDate date: Date, forceRefresh: Bool, completion: @escaping (NSDecimalNumber?, NSError?) -> ()) {
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
        let requestURL = URL(string: "\(OpenEchangeRatesAPIHistorycalAddress)\(dayString).json?base=\(base)&app_id=\(OpenExchangeAppID)")!
        Log.debug("\(requestURL)")
        let request = URLRequest(url: requestURL)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            Log.debug("Request completed")
            
            if let error = error {
                completion(nil, error as NSError?)
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
        }) 
        
        task.resume()
    }
}
