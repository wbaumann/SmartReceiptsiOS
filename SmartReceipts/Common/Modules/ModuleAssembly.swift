//
//  ModuleAssembly.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 04/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation

class ModuleAssembly {
    var serviceFactory: ServiceFatoryProtocol
    
    init(serviceFactory: ServiceFatoryProtocol = ServiceFactory.shared) {
        self.serviceFactory = serviceFactory
    }
}
