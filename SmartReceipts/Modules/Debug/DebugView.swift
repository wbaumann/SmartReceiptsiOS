//
//  DebugView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 03/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift
import RxCocoa

//MARK: - Public Interface Protocol
protocol DebugViewInterface {
    var loginTap: Observable<Void> { get }
}

//MARK: DebugView Class
final class DebugView: UserInterface {
    
    
    fileprivate var formView: DebugFormView?
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        
        formView = DebugFormView()
        
        addChildViewController(formView!)
        view.addSubview(formView!.view)
        configureUIActions()
        
        super.viewDidLoad()
    }
    
    private func configureUIActions() {
        
    }
    
    
    
}

//MARK: - Public interface
extension DebugView: DebugViewInterface {
    var loginTap: Observable<Void> { return formView!.rx.loginTap }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension DebugView {
    var presenter: DebugPresenter {
        return _presenter as! DebugPresenter
    }
    var displayData: DebugDisplayData {
        return _displayData as! DebugDisplayData
    }
}
