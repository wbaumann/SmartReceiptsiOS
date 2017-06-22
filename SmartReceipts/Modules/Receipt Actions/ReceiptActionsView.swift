//
//  ReceiptActionsView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit

//MARK: - Public Interface Protocol
protocol ReceiptActionsViewInterface {
    var doneButton: UIBarButtonItem {get}
}

//MARK: ReceiptActionsView Class
final class ReceiptActionsView: UserInterface {
    
    @IBOutlet fileprivate weak var doneButtonItem: UIBarButtonItem!
    
    var formView: ReceiptActionsFormView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formView = ReceiptActionsFormView(attachmentType: .none)
        
        formView.handleAttachTap = presenter.handleAttachTap
        formView.takeImageTap = presenter.takeImageTap
        formView.retakeImageTap = presenter.retakeImageTap
        formView.viewImageTap = presenter.viewImageTap
        formView.moveTap = presenter.moveTap
        formView.copyTap = presenter.copyTap
        formView.swapUpTap = presenter.swapUpTap
        formView.swapDownTap = presenter.swapDownTap
        
        addChildViewController(formView)
        view.addSubview(formView.view)
    }
    
}

//MARK: - Public interface
extension ReceiptActionsView: ReceiptActionsViewInterface {
    var doneButton: UIBarButtonItem { get{ return doneButtonItem } }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptActionsView {
    var presenter: ReceiptActionsPresenter {
        return _presenter as! ReceiptActionsPresenter
    }
    var displayData: ReceiptActionsDisplayData {
        return _displayData as! ReceiptActionsDisplayData
    }
}
