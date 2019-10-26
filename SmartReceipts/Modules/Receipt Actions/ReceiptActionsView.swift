//
//  ReceiptActionsView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift

//MARK: - Public Interface Protocol
protocol ReceiptActionsViewInterface {
    var doneButton: UIBarButtonItem { get }
    func setup(receipt: WBReceipt)
    func updateForm()
}

//MARK: ReceiptActionsView Class
final class ReceiptActionsView: UserInterface {
    private let bag = DisposeBag()
    
    @IBOutlet fileprivate weak var doneButtonItem: UIBarButtonItem!
    
    var formView: ReceiptActionsFormView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = displayData.receipt.name
        
        formView = ReceiptActionsFormView(attachmentType: displayData.receipt.attachemntType)
        
        formView.actionSubject
            .bind(to: presenter.actionTap)
            .disposed(by: bag)
        
        addChild(formView)
        view.addSubview(formView.view)
    }
    
}

//MARK: - Public interface
extension ReceiptActionsView: ReceiptActionsViewInterface {
    var doneButton: UIBarButtonItem { get{ return doneButtonItem } }
    
    func setup(receipt: WBReceipt) {
        displayData.receipt = receipt
    }
    
    func updateForm() {
        formView.attachmentType = displayData.receipt.attachemntType
        formView.update()
    }
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
