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

class DebugFormView: FormViewController {
    
    fileprivate let loginSubject = PublishSubject<Void>()
    fileprivate let subscriptionSubject = PublishSubject<Bool>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form
        +++ Section()
        <<< ButtonRow() { row in
            row.title = "Login"
        }.onCellSelection({ [unowned self] _ in
            self.loginSubject.onNext()
        })
        
        <<< SwitchRow() { row in
            row.title = "Subscription"
            row.value = DebugStates.subscription()
        }.onChange({ [unowned self] row in
            self.subscriptionSubject.onNext(row.value!)
        })
    }
    
}

extension Reactive where Base: DebugFormView  {
    var loginTap: Observable<Void> { return base.loginSubject }
    var subscriptionChange: Observable<Bool> { return base.subscriptionSubject }
}
