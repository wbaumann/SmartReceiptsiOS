//
//  ReceiptMoveCopyPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 22/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class ReceiptMoveCopyPresenter: Presenter {
    
    var isCopyOrMove: Bool!
    var receipt: WBReceipt!
    let tripTapSubject = PublishSubject<WBTrip>()
    
    override func viewHasLoaded() {
        super.viewHasLoaded()
        interactor.configureSubscribers()
    }
    
    override func setupView(data: Any) {
        let inputData = data as! (receipt: WBReceipt, isCopyOrMove: Bool)
        self.isCopyOrMove = inputData.isCopyOrMove
        self.receipt = inputData.receipt
        view.setup(fetchedModelAdapter: interactor.fetchedModelAdapter(for: inputData.receipt))
    }
    
    func close() {
        router.close()
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptMoveCopyPresenter {
    var view: ReceiptMoveCopyViewInterface {
        return _view as! ReceiptMoveCopyViewInterface
    }
    var interactor: ReceiptMoveCopyInteractor {
        return _interactor as! ReceiptMoveCopyInteractor
    }
    var router: ReceiptMoveCopyRouter {
        return _router as! ReceiptMoveCopyRouter
    }
}
