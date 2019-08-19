//
//  OrganizationModelsConverter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 28/07/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation

class OrganizationModelsConverter {
    
    // MARK: From Backend models to DB
    
    func convertCategory(model: CategoryModel) -> WBCategory {
        return WBCategory(name: model.name, code: model.code, uuid: model.uuid)
    }
    
    func convertPaymentMethod(model: PaymentMethodModel) -> PaymentMethod {
        return PaymentMethod(objectId: 0, method: model.code, uuid: model.uuid)
    }
    
    func convertColumn(model: ColumnModel) -> ReceiptColumn {
        let type = Int(string: model.columnType) ?? 0
        return ReceiptColumn(type: type, uuid: model.uuid)
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
    
    // MARK: From DB models to Backend models
    
    func convertCategory(category: WBCategory) -> CategoryModel {
        return CategoryModel(uuid: category.uuid, code: category.code, name: category.name)
    }
    
    func convertPaymentMethod(method: PaymentMethod) -> PaymentMethodModel {
        return PaymentMethodModel(uuid: method.uuid, code: method.method)
    }
    
    func convertColumn(column: ReceiptColumn) -> ColumnModel {
        return ColumnModel(uuid: column.uuid, columnType: "\(column.сolumnType)")
    }
    
    func convertCategories(_ categories: [WBCategory]) -> [CategoryModel] {
        return categories.map { self.convertCategory(category: $0) }
    }
    
    func convertPaymentMethods(_ methods: [PaymentMethod]) -> [PaymentMethodModel] {
        return methods.map { self.convertPaymentMethod(method: $0) }
    }
    
    func convertColumns(_ columns: [ReceiptColumn]) -> [ColumnModel] {
        return columns.map { self.convertColumn(column: $0) }
    }
    
}
