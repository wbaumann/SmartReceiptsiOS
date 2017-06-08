//
//  GenerateReportPresenter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

final class GenerateReportPresenter: Presenter {
    
    let fullPdfReport = BehaviorSubject<Bool>(value: false)
    let pdfReportWithoutTable = BehaviorSubject<Bool>(value: false)
    let csvFile = BehaviorSubject<Bool>(value: false)
    let zipStampedJPGs = BehaviorSubject<Bool>(value: false)
    
    override func viewHasLoaded() {
        interactor.configureBinding()
        interactor.trackConfigureReportEvent()
    }
    
    override func setupView(data: Any) {
        if let trip = data as? WBTrip {
            interactor.generator = ReportAssetsGenerator(trip: trip)
            interactor.shareService = GenerateReportShareService(presenter: self, trip: trip)
        }
    }
    
    func close() {
        router.close()
    }
    
    func generateReport() {
        interactor.trackGeneratorEvents()
        interactor.generateReport()
    }
    
    func presentAlert(title: String, message: String) {
        router.openAlert(title: title, message: message)
    }
    
    func presentSheet(title: String?, message: String?, actions: [UIAlertAction]) {
        router.openSheet(title: title, message: message, actions: actions)
    }
    
    func present(vc: UIViewController, animated: Bool = true, isPopover: Bool = false, completion: (() -> Void)? = nil) {
        router.open(vc: vc, animated: animated, isPopover: isPopover, completion: completion)
    }
    
    func presentSettings() {
        router.openSettings()
    }
    
    func hideHudFromView() {
        view.hideHud()
    }

}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension GenerateReportPresenter {
    var view: GenerateReportViewInterface {
        return _view as! GenerateReportViewInterface
    }
    var interactor: GenerateReportInteractor {
        return _interactor as! GenerateReportInteractor
    }
    var router: GenerateReportRouter {
        return _router as! GenerateReportRouter
    }
}
