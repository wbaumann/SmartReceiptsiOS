//
//  PaymentMethod.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 18/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension PaymentMethod {
    class func defaultMethod(database: Database = Database.sharedInstance()) -> PaymentMethod {
        let allMethods = database.allPaymentMethods()
        for method in allMethods {
            if method.method == NSLocalizedString("payment.method.unspecified", comment: "") {
                return method
            }
        }
        
        return allMethods.first!
    }
}