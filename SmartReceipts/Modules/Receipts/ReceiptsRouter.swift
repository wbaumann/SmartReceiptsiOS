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
    private let bag = DisposeBag()
    private var subscription: Disposable?
    
    func openDistances() {
        let module = AppModules.tripDistances.build()
        executeFor(iPhone: {
            module.router.show(from: _view, embedInNavController: true, setupData: moduleTrip)
        }, iPad: {
            module.router.showIPadForm(from: _view, setupData: moduleTrip, needNavigationController: true)
        })
    }
    
    func openImageViewer(for receipt: WBReceipt) {
        Observable<Void>.just(())
            .delay(0, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                let module = AppModules.receiptImageViewer.build()
                module.router.show(from: self._view, embedInNavController: false, setupData: receipt)
            }).disposed(by: bag)
    }
    
    func openPDFViewer(for receipt: WBReceipt) {
        Observable<Void>.just(())
            .delay(0, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                let url = URL(fileURLWithPath: receipt.imageFilePath(for: receipt.trip))
                self.documentViewController = UIDocumentInteractionController(url: url)
                self.documentViewController.name = receipt.name
                self.documentViewController.delegate = self._view as? UIDocumentInteractionControllerDelegate
                self.documentViewController.presentPreview(animated: true)
            }).disposed(by: bag)
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
        openEditModuleWith(receipt: nil)
    }
    
    func openCreatePhotoReceipt() {
        var hud: PendingHUDView?
        self.subscription = ImagePicker.shared.presentCamera(on: _view)
            .flatMap({ img -> Single<Scan> in
                hud = PendingHUDView.showFullScreen(text: ScanStatus.uploading.localizedText)
                hud?.observe(status: self.presenter.scanService.status)
                return self.presenter.scanService.scan(image: img)
            }).subscribe(onSuccess: { [unowned self] scan in
                hud?.hide()
                self.openEditModule(with: scan)
            })
    }
    
    func openImportReceiptFile() {
        var hud: PendingHUDView?
        ReceiptFilePicker.sharedInstance.openFilePicker(on: _view)
            .do(onError: { [unowned self] error in
                Logger.error("Import failed with: \(error.localizedDescription)")
                self.openAlert(title: nil, message: error.localizedDescription)
            }).subscribe(onNext: { [unowned self] doc in
                hud = PendingHUDView.showFullScreen(text: ScanStatus.uploading.localizedText)
                hud?.observe(status: self.presenter.scanService.status)
                self.subscription = self.presenter.scanService.scan(document: doc)
                    .subscribe(onSuccess: { [unowned self] scan in
                        hud?.hide()
                        self.openEditModule(with: scan)
                    })
            }, onError: { [unowned self] _ in
                self.openEditModuleWith(receipt: nil)
            }).disposed(by: bag)
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
    
    func openEdit(receipt: WBReceipt) {
        openEditModuleWith(receipt: receipt)
    }
    
    private func openEditModuleWith(receipt: WBReceipt?) {
        subscription?.dispose()
        subscription = nil
        
        let module = AppModules.editReceipt.build()
        let data = (trip: moduleTrip, receipt: receipt)
        executeFor(iPhone: {
            module.router.show(from: _view, embedInNavController: true, setupData: data)
        }, iPad: {
            module.router.showIPadForm(from: _view, setupData: data, needNavigationController: true)
        })
    }
    
    private func openEditModule(with scan: Scan) {
        let module = AppModules.editReceipt.build()
        let data = (trip: moduleTrip, scan: scan)
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
