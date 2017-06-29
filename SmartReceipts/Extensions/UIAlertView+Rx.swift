//
//  UIAlertView+Rx.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 29/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift

extension UIAlertView {
    class func rx_show(title: String? = nil, message: String? = nil,
                    delegate: UIAlertViewDelegate? = nil, cancelButtonTitle: String? = nil) -> Observable<UIAlertView> {
        let alert = UIAlertView(title: title, message: message, delegate: delegate, cancelButtonTitle: cancelButtonTitle)
        alert.show()
        return Observable<UIAlertView>.just(alert)
    }
}
