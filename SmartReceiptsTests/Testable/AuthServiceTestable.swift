//
//  AuthServiceTestable.swift
//  SmartReceiptsTests
//
//  Created by Bogdan Evsenev on 06/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

@testable import SmartReceipts
import RxSwift
import SwiftyJSON

class AuthServiceTestable: AuthServiceInterface {
    var isLoggedInValue = true
    var isLoggedIn: Bool {
        return isLoggedInValue
    }
}
