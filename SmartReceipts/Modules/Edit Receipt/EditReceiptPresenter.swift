//
//  EditReceiptPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class EditReceiptPresenter: Presenter {
    
    let addReceiptSubject = PublishSubject<WBReceipt>()
    let updateReceiptSubject = PublishSubject<WBReceipt>()
    let settingsTap = PublishSubject<Void>()
    
    private let bag = DisposeBag()
    
    override func viewHasLoaded() {
        interactor.configureSubscribers()
        settingsTap.subscribe(onNext: { [unowned self] in
            self.router.openSettings()
        }).disposed(by: bag)
    }
    
    override func setupView(data: Any) {
        if let inputData = data as? (trip: WBTrip, receipt: WBReceipt?, image: UIImage?) {
            view.setup(trip: inputData.trip, receipt: inputData.receipt)
            interactor.receiptImage = inputData.image
        } else {
            let scanData = data as! (trip: WBTrip, scan: Scan)
            view.setup(trip: scanData.trip, receipt: nil)
            view.setup(scan: scanData.scan)
            interactor.receiptImage = scanData.scan.image
        }
    }
    
    func close() {
        router.close()
    }
    
    func present(errorDescription: String) {
        router.openAlert(title: nil, message: errorDescription)
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditReceiptPresenter {
    var view: EditReceiptViewInterface {
        return _view as! EditReceiptViewInterface
    }
    var interactor: EditReceiptInteractor {
        return _interactor as! EditReceiptInteractor
    }
    var router: EditReceiptRouter {
        return _router as! EditReceiptRouter
    }
}
