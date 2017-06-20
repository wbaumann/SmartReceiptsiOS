//
//  EditReceiptInteractor.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class EditReceiptInteractor: Interactor {
    
    var receiptImage: UIImage?
    let disposeBag = DisposeBag()
    
    func configureSubscribers() {
        presenter.addReceiptSubject.subscribe(onNext: { [weak self] receipt in
            Logger.debug("Added Receipt: \(receipt.name)")
            AnalyticsManager.sharedManager.record(event: Event.receiptsPersistNewReceipt())
            self?.save(receipt: receipt)
        }).disposed(by: disposeBag)
        
        presenter.updateReceiptSubject.subscribe(onNext: { [weak self] receipt in
            Logger.debug("Updated Receipt: \(receipt.name)")
            AnalyticsManager.sharedManager.record(event: Event.receiptsPersistUpdateReceipt())
            
            if let img = self?.receiptImage {
                var imgFileName = ""
                let nextId = Database.sharedInstance().nextReceiptID()
                imgFileName = String(format: "%tu_%@.jpg", nextId, receipt.name)
                let path = receipt.trip.file(inDirectoryPath: imgFileName)
                if !WBFileManager.forceWrite(UIImageJPEGRepresentation(img, 0.85), to: path) {
                    imgFileName = ""
                } else {
                    receipt.setImageFileName(imgFileName)
                }
            }
            self?.save(receipt: receipt)
        }).disposed(by: disposeBag)
    }
    
    private func save(receipt: WBReceipt) {
        if !Database.sharedInstance().save(receipt) {
            presenter.present(errorDescription: LocalizedString("edit.receipt.generic.save.error.message"))
        } else {
            presenter.close()
        }
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditReceiptInteractor {
    var presenter: EditReceiptPresenter {
        return _presenter as! EditReceiptPresenter
    }
}
