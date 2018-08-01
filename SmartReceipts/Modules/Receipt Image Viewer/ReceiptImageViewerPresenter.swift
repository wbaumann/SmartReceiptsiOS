//
//  ReceiptImageViewerPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 23/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import RxCocoa

class ReceiptImageViewerPresenter: Presenter {
    
    let image = BehaviorRelay<UIImage?>(value: nil)
    var receipt: WBReceipt!
    
    override func setupView(data: Any) {
        receipt = data as! WBReceipt
        view.setup(receipt: receipt)
        let path = receipt.imageFilePath(for: receipt.trip)
        image.accept(UIImage(contentsOfFile: path))
        interactor.imagePath = path
        interactor.configureSubscribers()
    }
    
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptImageViewerPresenter {
    var view: ReceiptImageViewerViewInterface {
        return _view as! ReceiptImageViewerViewInterface
    }
    var interactor: ReceiptImageViewerInteractor {
        return _interactor as! ReceiptImageViewerInteractor
    }
    var router: ReceiptImageViewerRouter {
        return _router as! ReceiptImageViewerRouter
    }
}
