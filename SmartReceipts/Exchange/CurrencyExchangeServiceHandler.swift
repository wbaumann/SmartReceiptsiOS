//
//  CurrencyExchangeServiceHandler.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

enum ExchangeServiceStatus {
    case NotEnabled
    case Success
    case RetriveError
}

protocol CurrencyExchangeServiceHandler {
    func exchangeRate(base: String, target: String, onDate date: NSDate, completion: (ExchangeServiceStatus, NSDecimalNumber?) -> ())
}

extension CurrencyExchangeServiceHandler {
    func exchangeRate(base: String, target: String, onDate date: NSDate, completion: (ExchangeServiceStatus, NSDecimalNumber?) -> ()) {
        // TODO jaanus: if no subscription return  with NotEnabled
        
        OpenExchangeRates.sharedInstance.exchangeRate(base, target: target, onDate: date) {
            rate, error in
            
            if let error = error {
                Log.error("Exchange rate error: \(error)")                
            }
            
            guard let rate = rate else {
                completion(.RetriveError, nil)
                return
            }
            
            completion(.Success, rate)
        }
    }
}