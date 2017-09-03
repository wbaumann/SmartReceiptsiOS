//
//  DebugFormView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Eureka
import RxSwift
import RxCocoa

private let LOGIN_ROW_TAG = "LoginRow"

class DebugFormView: FormViewController {
    
    fileprivate let loginSubject = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form
        +++ Section()
        <<< ButtonRow(LOGIN_ROW_TAG) { row in
            row.title = "Login"
        }.onCellSelection({ [unowned self] _ in
            self.loginSubject.onNext()
        })
    }
    
}

extension Reactive where Base: DebugFormView  {
    var loginTap: Observable<Void> { return base.loginSubject }
}
