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
import UserNotifications

fileprivate let ANIMATIONS_DURATION: RxTimeInterval = 0.6

protocol EditReceiptModuleInterface {
    func disableFirstResponder()
    func makeNameFirstResponder()
}

class EditReceiptPresenter: Presenter {
    
    let addReceiptSubject = PublishSubject<WBReceipt>()
    let updateReceiptSubject = PublishSubject<WBReceipt>()
    let settingsTap = PublishSubject<Void>()
    let tooltipClose = PublishSubject<Void>()
    let tooltipTap = PublishSubject<Void>()
    
    private let bag = DisposeBag()
    
    override func viewHasLoaded() {
        interactor.configureSubscribers()
        settingsTap.subscribe(onNext: { [unowned self] in
            self.router.openSettings()
        }).disposed(by: bag)
        
        tooltipTap.subscribe(onNext: { [unowned self] in
            let authModule = self.router.openAuth()
            _ = authModule.successAuth
                .map({ authModule.close() })
                .delay(ANIMATIONS_DURATION, scheduler: MainScheduler.instance)
                .flatMap({ _ -> Observable<UNAuthorizationStatus> in
                    PushNotificationService.shared.authorizationStatus()
                }).flatMap({ status -> Observable<Void> in
                    let text = LocalizedString("push.request.alert.text")
                    return status == .notDetermined ? UIAlertController.showInfo(text: text) : Observable<Void>.just()
                }).subscribe(onNext: { [unowned self] in
                    _ = PushNotificationService.shared.requestAuthorization().subscribe()
                    self.router.openAutoScans()
                })
        }).disposed(by: bag)
    }
    
    override func setupView(data: Any) {
        if let inputData = data as? (trip: WBTrip, receipt: WBReceipt?) {
            view.setup(trip: inputData.trip, receipt: inputData.receipt)
        } else if let scanData = data as? (trip: WBTrip, scan: Scan) {
            view.setup(trip: scanData.trip, receipt: nil)
            view.setup(scan: scanData.scan)
            interactor.receiptFilePath = scanData.scan.filepath
        }
    }
    
    func close() {
        router.close()
    }
    
    func present(errorDescription: String) {
        router.openAlert(title: nil, message: errorDescription)
    }
    
    func tooltipText() -> String? {
        return interactor.tooltipText()
    }
}

// MARK: EditReceiptModuleInterface

extension EditReceiptPresenter: EditReceiptModuleInterface {
    func disableFirstResponder() {
        view.disableFirstResponeder()
    }
    
    func makeNameFirstResponder() {
        view.makeNameFirstResponder()
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
