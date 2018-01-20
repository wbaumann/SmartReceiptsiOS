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
            }).disposed(by: bag)
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
        openEditModuleWith(receipt: nil, image: nil)
    }
    
    func openCreatePhotoReceipt() {
        var hud: PendingHUDView?
        ImagePicker.sharedInstance().rx_openCamera(on: _view)
            .filter({ $0 != nil })
            .map({ $0! })
            .flatMap({ [unowned self] img -> Observable<Scan> in
                hud = PendingHUDView.showFullScreen(text: ScanStatus.uploading.localizedText)
                hud?.observe(status: self.presenter.scanService.status)
                return self.presenter.scanService.scan(image: img)
            }).subscribe(onNext: { [unowned self] scan in
                hud?.hide()
                self.openEditModule(with: scan)
            }).disposed(by: bag)
    }
    
    func openImportReceiptFile() {
        var hud: PendingHUDView?
        if #available(iOS 11.0, *) {
            ReceiptFilePicker.sharedInstance.openFilePicker(on: _view)
                .subscribe(onNext: { doc in
                    guard let img = doc.image else { return }
                    hud = PendingHUDView.showFullScreen(text: ScanStatus.uploading.localizedText)
                    hud?.observe(status: self.presenter.scanService.status)
                    _ = self.presenter.scanService.scan(image: img).subscribe(onNext: { [unowned self] scan in
                        hud?.hide()
                        self.openEditModule(with: scan)
                    })
                    
                }).disposed(by: bag)
        }
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
