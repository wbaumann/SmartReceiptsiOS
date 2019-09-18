//
//  ServiceFactory.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 04/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation

protocol ServiceFatoryProtocol {
    var authService: AuthServiceInterface { get }
    var organizationService: OrganizationsServiceInterface { get }
    var purchaseService: PurchaseService { get }
}

class ServiceFactory: ServiceFatoryProtocol {
    static let shared: ServiceFatoryProtocol = ServiceFactory()
    
    var authService: AuthServiceInterface = {
        return AuthService.shared
    }()
    
    var organizationService: OrganizationsServiceInterface = {
        return OrganizationsService()
    }()
    
    var purchaseService: PurchaseService = {
        return PurchaseService()
    }()
}
