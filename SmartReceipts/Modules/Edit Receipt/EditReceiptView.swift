//
//  EditReceiptView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift

//MARK: - Public Interface Protocol
protocol EditReceiptViewInterface {
    func setup(trip: WBTrip, receipt: WBReceipt?)
}

//MARK: EditReceiptView Class
final class EditReceiptView: UserInterface {
    
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    
    private var formView: EditReceiptFormView!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formView = EditReceiptFormView(trip: displayData.trip, receipt: displayData.receipt)
        addChildViewController(formView)
        view.addSubview(formView.view)
        configureUIActions()
        configureSubscribers()
    }
    
    private func configureUIActions() {
        cancelButton.rx.tap.subscribe(onNext: {
            self.presenter.close()
        }).disposed(by: disposeBag)
        
        doneButton.rx.tap.subscribe(onNext: {
            self.formView.validate()
        }).disposed(by: disposeBag)
    }
    
    private func configureSubscribers() {
        formView.receiptSubject.subscribe(onNext: { receipt in
            self.displayData.receipt == nil ?
                self.presenter.addReceiptSubject.onNext(receipt) :
                self.presenter.updateReceiptSubject.onNext(receipt)
        }).addDisposableTo(disposeBag)
        
        formView.errorSubject.subscribe(onNext: { errorDescription in
            self.presenter.present(errorDescription: errorDescription)
        }).addDisposableTo(disposeBag)
    }
    
}

//MARK: - Public interface
extension EditReceiptView: EditReceiptViewInterface {
    func setup(trip: WBTrip, receipt: WBReceipt?) {
        displayData.trip = trip
        displayData.receipt = receipt
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditReceiptView {
    var presenter: EditReceiptPresenter {
        return _presenter as! EditReceiptPresenter
    }
    var displayData: EditReceiptDisplayData {
        return _displayData as! EditReceiptDisplayData
    }
}
