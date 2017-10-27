//
//  ScansPurchaseButton.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 27/10/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift

class ScansPurchaseButton: UIButton {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet fileprivate weak var price: UILabel!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    
    func setScans(count: Int) {
        let titleFormat = LocalizedString("ocr.configuration.module.purchase.title")
        title.text = String(format: titleFormat, count)
        
        let subtitleFormat = LocalizedString("ocr.configuration.module.purchase.subtitle")
        subtitle.text = String(format: subtitleFormat, count)
    }
}

extension Reactive where Base: ScansPurchaseButton {
    var price: AnyObserver<String> {
        return AnyObserver<String>(onNext: { [unowned base] price in
            base.price.text = price
            base.activityIndicator.stopAnimating()
        })
    }
}
