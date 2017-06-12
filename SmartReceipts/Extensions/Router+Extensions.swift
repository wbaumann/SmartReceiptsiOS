//
//  Router+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Viperit

extension Router {
    func openAlert(title: String?, message: String) {
        UIAlertView(title: title, message: message, delegate: nil,
                    cancelButtonTitle: LocalizedString("generic.button.title.ok")).show()
    }
}
