//
//  Toast+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 09/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Toaster

extension Toast {
    class func show(_ text: String) {
        let toast = Toast(text: text)
        toast.duration = 3
        toast.view.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
        toast.show()
    }
}
