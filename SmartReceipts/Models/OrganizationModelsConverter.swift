//
//  OrganizationModelsConverter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 28/07/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation

class OrganizationModelsConverter {
    
    func convertCategory(model: CategoryModel) -> WBCategory {
        return WBCategory(name: model.name, code: model.code)
    }
    
    func convertPaymentMethod(model: PaymentMethodModel) -> PaymentMethod {
        return PaymentMethod(objectId: 0, method: model.code)
    }
    
    func convertColumn(model: ColumnModel) -> ReceiptColumn {
        let type = Int(string: model.columnType) ?? 0
        return ReceiptColumn(type: type)
    }
    
    func convertCategories(models: [CategoryModel]) -> [WBCategory] {
        return models.map { self.convertCategory(model: $0) }
    }
    
    func convertPaymentMethods(models: [PaymentMethodModel]) -> [PaymentMethod] {
        return models.map { self.convertPaymentMethod(model: $0) }
    }
    
    func convertColumns(models: [ColumnModel]) -> [ReceiptColumn] {
        return models.map { self.convertColumn(model: $0) }
    }
}
