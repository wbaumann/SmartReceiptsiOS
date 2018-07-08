//
//  ReceiptImageViewerInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 23/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class ReceiptImageViewerInteractor: Interactor {
    
    var imagePath: String!
    let bag = DisposeBag()
    
    func configureSubscribers() {
        presenter.image.asObservable()
            .filter({ $0 != nil })
            .observeOn(ConcurrentDispatchQueueScheduler(queue: AppDelegate.instance.dataQueue))
            .subscribe(onNext: { [unowned self] image in
            
            let isPNG = ((self.imagePath as NSString).pathExtension as NSString)
                .caseInsensitiveCompare("png") == .orderedSame
            
            let data = isPNG ?
                UIImagePNGRepresentation(image!) :
                UIImageJPEGRepresentation(image!, kImageCompression)
            
            _ = FileManager.forceWrite(data: data!, to: self.imagePath)
        }).disposed(by: bag)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptImageViewerInteractor {
    var presenter: ReceiptImageViewerPresenter {
        return _presenter as! ReceiptImageViewerPresenter
    }
}
