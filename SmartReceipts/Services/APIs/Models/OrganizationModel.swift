//
//  Organization.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/07/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation

struct OrganizationModel: Codable {
    let id: String
    let name: String
    let createdAt: Date
    let appSettings: OrganizationAppSettings
    let error: OrganizationError
    let users: [OrganizationUser]
    
    enum CodingKeys: String, CodingKey {
        case id, name, error
        case createdAt = "created_at_iso8601"
        case appSettings = "app_settings"
        case users = "organization_users"
    }
}

struct OrganizationUser: Codable {
    let id: String
    let organizationId: String
    let userId: String
    let createdAt: Date
    let updatedAt: Date
    let role: Role
    
    enum CodingKeys: String, CodingKey {
        case id, role
        case organizationId = "organization_id"
        case createdAt = "created_at_iso8601"
        case updatedAt = "updated_at_iso8601"
        case userId = "user_id"
    }
    
    enum Role: Int, Codable {
        case admin = 1
        case supportAdmin = 5
        case user = 10
    }
}

struct OrganizationError: Codable {
    let hasError: Bool
    let errors: [String]
    
    enum CodingKeys: String, CodingKey {
        case errors
        case hasError = "has_error"
    }
}

struct OrganizationAppSettings: Codable {
    let configurations: ConfigurationsModel
    let settings: SettingsModel
    let categories: [CategoryModel]
    let paymentMethods: [PaymentMethodModel]
    let pdfColumns: [ColumnModel]
    let csvColumns: [ColumnModel]
    
    enum CodingKeys: String, CodingKey {
        case configurations = "Configurations"
        case settings = "Settings"
        case categories = "Categories"
        case paymentMethods = "PaymentMethods"
        case pdfColumns = "PDFColumns"
        case csvColumns = "CSVColumns"
    }
}

struct SettingsModel: Codable, Equatable {
    let tripDuration: Int?
    let isocurr: String?
    let dateformat: String?
    let trackcostcenter: Bool?
    let predictCategories: Bool?
    let matchNameCategories: Bool?
    let matchCommentCategories: Bool?
    let onlyIncludeExpensable: Bool?
    let expensableDefault: Bool?
    let includeTaxField: Bool?
    let taxPercentage: Float?
    let preTax: Bool?
    let enableAutoCompleteSuggestions: Bool?
    let minReceiptPrice: Float?
    let defaultToFirstReportDate: Bool?
    let showReceiptID: Bool?
    let useFullPage: Bool?
    let usePaymentMethods: Bool?
    let printByIDPhotoKey: Bool?
    let printCommentByPhoto: Bool?
    let emailTo: String?
    let emailCC: String?
    let emailBCC: String?
    let emailSubject: String?
    let saveBW: Bool?
    let layoutIncludeReceiptDate: Bool?
    let layoutIncludeReceiptCategory: Bool?
    let layoutIncludeReceiptPicture: Bool?
    let mileageTotalInReport: Bool?
    let mileageRate: Double?
    let mileagePrintTable: Bool?
    let mileageAddToPDF: Bool?
    let pdfFooterString: String?
    
    enum CodingKeys: String, CodingKey {
        case isocurr, dateformat, trackcostcenter
        case tripDuration = "TripDuration"
        case predictCategories = "PredictCats"
        case matchNameCategories = "MatchNameCats"
        case matchCommentCategories = "MatchCommentCats"
        case onlyIncludeExpensable = "OnlyIncludeExpensable"
        case expensableDefault = "ExpensableDefault"
        case includeTaxField = "IncludeTaxField"
        case taxPercentage = "TaxPercentage"
        case preTax = "PreTax"
        case enableAutoCompleteSuggestions = "EnableAutoCompleteSuggestions"
        case minReceiptPrice = "MinReceiptPrice"
        case defaultToFirstReportDate = "DefaultToFirstReportDate"
        case showReceiptID = "ShowReceiptID"
        case useFullPage = "UseFullPage"
        case usePaymentMethods = "UsePaymentMethods"
        case printByIDPhotoKey = "PrintByIDPhotoKey"
        case printCommentByPhoto = "PrintCommentByPhoto"
        case emailTo = "EmailTo"
        case emailCC = "EmailCC"
        case emailBCC = "EmailBCC"
        case emailSubject = "EmailSubject"
        case saveBW = "SaveBW"
        case layoutIncludeReceiptDate = "LayoutIncludeReceiptDate"
        case layoutIncludeReceiptCategory = "LayoutIncludeReceiptCategory"
        case layoutIncludeReceiptPicture = "LayoutIncludeReceiptPicture"
        case mileageTotalInReport = "MileageTotalInReport"
        case mileageRate = "MileageRate"
        case mileagePrintTable = "MileagePrintTable"
        case mileageAddToPDF = "MileageAddToPDF"
        case pdfFooterString = "PdfFooterString"
    }
}

struct ConfigurationsModel: Codable {
    let isSettingsEnable: Bool?
    
    enum CodingKeys: String, CodingKey {
        case isSettingsEnable = "IsSettingsEnable"
    }
}

struct CategoryModel: Codable, Equatable {
    let uuid: String
    let code: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case code = "Code"
        case name = "Name"
    }
}

struct PaymentMethodModel: Codable, Equatable {
    let uuid: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case code = "Code"
    }
}

struct ColumnModel: Codable, Equatable {
    let uuid: String
    let columnType: String
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case columnType = "column_type"
    }
}

extension OrganizationModel {
    func updatedBy(settings: OrganizationAppSettings) -> OrganizationModel {
        return .init(id: id, name: name, createdAt: createdAt, appSettings: settings, error: error, users: users)
    }
}
