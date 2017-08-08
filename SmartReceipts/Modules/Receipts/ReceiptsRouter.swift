//
//  ReceiptsRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift

class ReceiptsRouter: Router {
    
    var moduleTrip: WBTrip! = nil
    private var documentViewController: UIDocumentInteractionController!
    private let disposeBag = DisposeBag()
    
    func openDistances() {
        let module = AppModules.tripDistances.build()
        executeFor(iPhone: {
            module.router.show(from: _view, embedInNavController: true, setupData: moduleTrip)
        }, iPad: {
            module.router.showIPadForm(from: _view, setupData: moduleTrip, needNavigationController: true)
        })
    }
    
    func openImageViewer(for receipt: WBReceipt) {
        Observable<Void>.just()
            .delay(0, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                let module = AppModules.receiptImageViewer.build()
                module.router.show(from: self._view, embedInNavController: false, setupData: receipt)
            }).disposed(by: disposeBag)
    }
    
    func openPDFViewer(for receipt: WBReceipt) {
        Observable<Void>.just()
            .delay(0, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                let url = URL(fileURLWithPath: receipt.imageFilePath(for: receipt.trip))
                self.documentViewController = UIDocumentInteractionController(url: url)
                self.documentViewController.name = receipt.name
                self.documentViewController.delegate = self._view as? UIDocumentInteractionControllerDelegate
                self.documentViewController.presentPreview(animated: true)
            }).disposed(by: disposeBag)
    }
    
    func openGenerateReport() {
        let module = AppModules.generateReport.build()
        executeFor(iPhone: {
            module.router.show(from: _view, embedInNavController: true, setupData: moduleTrip)
        }, iPad: {
            module.router.showIPadForm(from: _view, setupData: moduleTrip, needNavigationController: true)
        })
    }
    
    func openCreateReceipt() {
        openEditModuleWith(receipt: nil, image: nil)
    }
    
    func openCreatePhotoReceipt() {
        ImagePicker.sharedInstance().rx_openOn(_view)
            .filter({ $0 != nil })
            .subscribe(onNext: { [unowned self] in
            self.openEditModuleWith(receipt: nil, image: $0)
        }).disposed(by: disposeBag)
    }
    
    func openActions(receipt: WBReceipt) -> ReceiptActionsPresenter {
        let module = AppModules.receiptActions.build()
        executeFor(iPhone: {
            module.router.show(from: _view, embedInNavController: true, setupData: receipt)
        }, iPad: {
            module.router.showIPadForm(from: _view, setupData: receipt, needNavigationController: true)
        })
        return module.presenter as! ReceiptActionsPresenter
    }
    
    func openEdit(receipt: WBReceipt, image: UIImage? = nil) {
        openEditModuleWith(receipt: receipt, image: image)
    }
    
    private func openEditModuleWith(receipt: WBReceipt?, image: UIImage?) {
        let module = AppModules.editReceipt.build()
        let data = (trip: moduleTrip, receipt: receipt, image: image)
        executeFor(iPhone: {
            module.router.show(from: _view, embedInNavController: true, setupData: data)
        }, iPad: {
            module.router.showIPadForm(from: _view, setupData: data, needNavigationController: true)
        })
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptsRouter {
    var presenter: ReceiptsPresenter {
        return _presenter as! ReceiptsPresenter
    }
}
