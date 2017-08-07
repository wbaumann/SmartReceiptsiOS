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
        presenter.addReceiptSubject.subscribe(onNext: { [unowned self] receipt in
            Logger.debug("Added Receipt: \(receipt.name)")
            AnalyticsManager.sharedManager.record(event: Event.receiptsPersistNewReceipt())
            self.saveImage(to: receipt)
            self.save(receipt: receipt)
        }).disposed(by: disposeBag)
        
        presenter.updateReceiptSubject.subscribe(onNext: { [unowned self] receipt in
            Logger.debug("Updated Receipt: \(receipt.name)")
            AnalyticsManager.sharedManager.record(event: Event.receiptsPersistUpdateReceipt())
            self.save(receipt: receipt)
        }).disposed(by: disposeBag)
    }
    
    private func save(receipt: WBReceipt) {
        if !Database.sharedInstance().save(receipt) {
            presenter.present(errorDescription: LocalizedString("edit.receipt.generic.save.error.message"))
            let action = receipt.objectId == 0 ? "insert" : "update"
            Logger.error("Can't \(action) receipt: \(receipt.description)")
        } else {
            validateDate(in: receipt)
            presenter.close()
        }
    }
    
    private func saveImage(to receipt: WBReceipt) {
        if let img = receiptImage {
            var imgFileName = ""
            let nextId = Database.sharedInstance().nextReceiptID()
            imgFileName = String(format: "%tu_%@.jpg", nextId, receipt.omittedName)
            let path = receipt.trip.file(inDirectoryPath: imgFileName)
            if !FileManager.forceWrite(data: UIImageJPEGRepresentation(img, 0.85)!, to: path!) {
                imgFileName = ""
            } else {
                receipt.setImageFileName(imgFileName)
            }
        }
    }
    
    private func validateDate(in receipt: WBReceipt) {
        Observable<Void>.just()
            .filter({ !WBPreferences.allowDataEntryOutsideTripBounds() })
            .filter({ receipt.date > receipt.trip.endDate || receipt.date < receipt.trip.startDate })
            .subscribe(onNext: {
                let title = LocalizedString("edit.receipt.date.range.warning.title")
                let message = LocalizedString("edit.receipt.date.range.warning.message")
                let okTitle = LocalizedString("generic.button.title.ok")
                _ = UIAlertView.rx_show(title: title, message: message, cancelButtonTitle: okTitle)
                    .delay(3, scheduler: MainScheduler.instance)
                    .subscribe(onNext: { alert in
                        alert.dismiss(withClickedButtonIndex: 0, animated: true)
                    })
        }).disposed(by: disposeBag)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditReceiptInteractor {
    var presenter: EditReceiptPresenter {
        return _presenter as! EditReceiptPresenter
    }
}
