//
//  PaymentMethod.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 18/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import FMDB

@objcMembers
class PaymentMethod: NSObject, FetchedModel, Pickable {
    var objectId: UInt = 0
    var method: String!
    var customOrderId: Int = 0
    var uuid: String! = ""
   
    required init(objectId: UInt, method: String) {
        super.init()
        self.objectId = objectId
        self.method = method
    }
    
    override required init() {
        super.init()
    }
    
    func loadData(from resultSet: FMResultSet!) {
        objectId = UInt(resultSet.int(forColumn: PaymentMethodsTable.Column.Id))
        method = resultSet.string(forColumn: PaymentMethodsTable.Column.Method)
        customOrderId = Int(resultSet.int(forColumn: PaymentMethodsTable.Column.CustomOrderId))
        uuid = resultSet.string(forColumn: CommonColumns.EntityUUID)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? PaymentMethod {
            return other === self || method == other.method
        } else {
            return false
        }
    }
    
    override var description: String { get { return self.method } }
    
    override var hash: Int { get { return NSNumber(value: objectId).hash } }
    
    func presentedValue() -> String! {
        return method
    }

    class func defaultMethod(_ database: Database = Database.sharedInstance()) -> PaymentMethod {
        let allMethods = database.allPaymentMethods()
        for method in allMethods! {
            if method.method == LocalizedString("payment_method_unspecified", comment: "") {
                return method
            } else if method.method == "Unspecified" {
                // For legacy reasons from before we started supporting translations, we use this as the default fallback option
                return method
            }
        }
        
        return allMethods!.first!
    }
}
