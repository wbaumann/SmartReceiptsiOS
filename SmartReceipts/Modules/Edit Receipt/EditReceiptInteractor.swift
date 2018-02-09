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
import Toaster

fileprivate let MIN_SCANS_TOOLTIP = 5

class EditReceiptInteractor: Interactor {
    private let bag = DisposeBag()
    private var authService: AuthServiceInterface!
    private var scansPurchaseTracker: ScansPurchaseTracker!
    private var tooltipService: TooltipService!
    var receiptFilePath: URL?
    let disposeBag = DisposeBag()
    
    required init(authService: AuthServiceInterface,
                  scansPurchaseTracker: ScansPurchaseTracker,
                  tooltipService: TooltipService)
    {
        self.authService = authService
        self.scansPurchaseTracker = scansPurchaseTracker
        self.tooltipService = tooltipService
    }
    
    convenience required init() {
        self.init(authService: AuthService.shared,
                  scansPurchaseTracker: ScansPurchaseTracker.shared,
                  tooltipService: TooltipService.shared)
    }
    
    
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
    
    func tooltipText() -> String? {
        if authService.isLoggedIn && scansPurchaseTracker.remainingScans < MIN_SCANS_TOOLTIP {
            let format = LocalizedString("ocr.informational.tooltip.limited.scans.text")
            return String.localizedStringWithFormat(format, scansPurchaseTracker.remainingScans)
        } else if !authService.isLoggedIn && !tooltipService.configureOCRDismissed() {
            presenter.tooltipClose
                .subscribe(onNext: { [unowned self] in
                    self.tooltipService.markConfigureOCRDismissed()
                }).disposed(by: bag)
            return LocalizedString("ocr.informational.tooltip.configure.text")
        }
        return nil
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
        if let url = receiptFilePath, let fileData = try? Data(contentsOf: url) {
            var imgFileName = ""
            let nextId = Database.sharedInstance().nextReceiptID()
            imgFileName = String(format: "%tu_%@.%@", nextId, receipt.omittedName, url.pathExtension)
            let path = receipt.trip.file(inDirectoryPath: imgFileName)
            if !FileManager.forceWrite(data: fileData, to: path!) {
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
                let message = LocalizedString("edit.receipt.date.range.warning.message")
                Toast.show(message)
        }).disposed(by: disposeBag)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditReceiptInteractor {
    var presenter: EditReceiptPresenter {
        return _presenter as! EditReceiptPresenter
    }
}
