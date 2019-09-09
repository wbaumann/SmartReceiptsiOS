//
//  Database+Organizations.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 04/09/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation

struct OrganizationSettingsModels {
    let categories: [CategoryModel]
    let paymentMethods: [PaymentMethodModel]
    let pdfColumns: [ColumnModel]
    let csvColumns: [ColumnModel]
}

extension Database {
    func importSettings(models: OrganizationSettingsModels) {
        let converter = OrganizationModelsConverter()
        
        let csvUuids = (allCSVColumns() as! [ReceiptColumn]).map { $0.uuid }
        let pdfUuids = (allPDFColumns() as! [ReceiptColumn]).map { $0.uuid }
        let pmUuids = allPaymentMethods().map { $0.uuid }
        let catUuids = listAllCategories().map { $0.uuid }
        
        converter.convertColumns(models: models.csvColumns)
            .filter { !csvUuids.contains($0.uuid) }
            .forEach { addCSVColumn($0) }
        
        converter.convertColumns(models: models.pdfColumns)
            .filter { !pdfUuids.contains($0.uuid) }
            .forEach { addPDFColumn($0) }
        
        converter.convertPaymentMethods(models: models.paymentMethods)
            .filter { !pmUuids.contains($0.uuid) }
            .forEach { save($0) }
        
        converter.convertCategories(models: models.categories)
            .filter { !catUuids.contains($0.uuid) }
            .forEach { save($0) }
    }
}

extension OrganizationAppSettings {
    var models: OrganizationSettingsModels {
        return OrganizationSettingsModels(
            categories: categories,
            paymentMethods: paymentMethods,
            pdfColumns: pdfColumns,
            csvColumns: csvColumns
        )
    }
    
}
