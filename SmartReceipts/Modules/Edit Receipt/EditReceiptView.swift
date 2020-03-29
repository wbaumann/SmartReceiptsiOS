//
//  EditReceiptView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift

//MARK: - Public Interface Protocol
protocol EditReceiptViewInterface {
    func setup(trip: WBTrip, receipt: WBReceipt?)
    func setup(scanResult: ScanResult)
    
    var removeAction: Observable<WBReceipt> { get }
    var showAttachmentAction: Observable<WBReceipt> { get }
    var manageCategoriesTap: Observable<Void>? { get }
    var managePaymentMethodsTap: Observable<Void>? { get }
    
    func disableFirstResponeder()
    func makeNameFirstResponder()
}

//MARK: EditReceiptView Class
final class EditReceiptView: UserInterface {
    
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    
    fileprivate weak var formView: EditReceiptFormView!
    private weak var tooltip: TooltipView?
    private let bag = DisposeBag()
    
    fileprivate let previewRemoveAction = PublishSubject<WBReceipt>()
    fileprivate let previewShowAttachmentAction = PublishSubject<WBReceipt>()
    
    override func viewDidLoad() {
        configureTitle()
        let formView = EditReceiptFormView(trip: displayData.trip, receipt: displayData.receipt)
        self.formView = formView
        formView.apply(scan: displayData.scanResult)
        formView.settingsTap = presenter.settingsTap
        formView.needFirstResponder = displayData.needFirstResponder
        addChild(formView)
        view.addSubview(formView.view)

        configureUIActions()
        configureSubscribers()
        configureTooltips()
        
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        tooltip?.updateFrame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureUIActions() {
        cancelButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.presenter.close()
        }).disposed(by: bag)
        
        doneButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.formView.validate()
        }).disposed(by: bag)
    }
    
    private func configureSubscribers() {
        formView.receiptSubject.subscribe(onNext: { [unowned self] receipt in
            self.displayData.receipt == nil ?
                self.presenter.addReceiptSubject.onNext(receipt) :
                self.presenter.updateReceiptSubject.onNext(receipt)
        }).disposed(by: bag)
        
        formView.errorSubject.subscribe(onNext: { [unowned self] errorDescription in
            self.presenter.present(errorDescription: errorDescription)
        }).disposed(by: bag)
    }
    
    private func configureTitle() {
        // We will add rx for database in future, and it will looks better.
        DispatchQueue(label: "com.smartreceipts.background").async { [weak self] in
            var newTitle: String!
            var id: UInt!
            if self?.displayData.receipt == nil {
                id = Database.sharedInstance().nextReceiptID()
                newTitle = LocalizedString("DIALOG_RECEIPTMENU_TITLE_NEW")
            } else {
                id = self?.displayData.receipt!.objectId
                newTitle = LocalizedString("DIALOG_RECEIPTMENU_TITLE_EDIT")
            }
            newTitle = WBPreferences.showReceiptID() ? newTitle + " - \(id!)" : newTitle
            DispatchQueue.main.async { [weak self] in
                self?.title = newTitle
            }
        }
    }
    
    private func configureTooltips() {
        guard let text = presenter.tooltipText() else {
            guard !WBPreferences.usePaymentMethods() && TooltipService.shared.paymentMethodHintAvailable() else { return }
            let tooltip = TooltipQuestion.showOn(view: view, text: LocalizedString("pref_receipt_use_payment_methods_title"), offset: .zero)
            formView.tableView.contentInset = UIEdgeInsets(top: TooltipView.HEIGHT, left: 0, bottom: 0, right: 0)
            
            tooltip.rx.yesAction
                .subscribe(onNext: { [weak self] in
                    WBPreferences.setUsePaymentMethods(true)
                    self?.formView.checkHiddenPaymentMethod()
                }).disposed(by: bag)
            
            Observable.merge([tooltip.rx.yesAction.asObservable(), tooltip.rx.noAction.asObservable()])
                .subscribe(onNext: { [weak self] in
                    self?.onTooltipClose()
                }).disposed(by: bag)
            
            tooltip.rx.noAction
                .subscribe(onNext: {
                    TooltipService.shared.markReportHintInteracted()
                }).disposed(by: bag)
            
            return
        }
        
        let tooltip = TooltipView.showOn(view: view, text: text, offset: .zero)
        formView.tableView.contentInset = UIEdgeInsets(top: TooltipView.HEIGHT, left: 0, bottom: 0, right: 0)
        
        Observable.merge([tooltip.rx.action.asObservable(), tooltip.rx.close.asObservable()])
            .do(onNext: { [weak self] in
                self?.onTooltipClose()
            }).bind(to: presenter.tooltipClose)
            .disposed(by: bag)
        
        tooltip.rx.action
            .bind(to: presenter.tooltipTap)
            .disposed(by: bag)
    }
    
    private func onTooltipClose() {
        UIView.animate(withDuration: DEFAULT_ANIMATION_DURATION, animations: {
            self.formView.tableView.contentInset = UIEdgeInsets.zero
        })
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        let removeActionTitle = LocalizedString("receipt_dialog_action_delete")
        let remove = UIPreviewAction(title: removeActionTitle, style: .destructive) { [weak self] _, _ in
            guard let receipt = self?.displayData.receipt else { return }
            self?.previewRemoveAction.onNext(receipt)
        }
        
        if let receipt = displayData.receipt, receipt.attachemntType != .none {
            let viewActionTitle = receipt.attachemntType == .image ?
                String(format: LocalizedString("receipt_dialog_action_view"), LocalizedString("image")) :
                String(format: LocalizedString("receipt_dialog_action_view"), LocalizedString("pdf"))
            
            let viewAttachment = UIPreviewAction(title: viewActionTitle, style: .default) { [weak self]  _, _ in
                self?.previewShowAttachmentAction.onNext(receipt)
            }
            
            return [viewAttachment, remove]
        }
        
        return [remove]
    }
    
}

//MARK: - Public interface
extension EditReceiptView: EditReceiptViewInterface {
    func makeNameFirstResponder() {
        formView.makeNameFirstResponder()
    }
    
    func setup(trip: WBTrip, receipt: WBReceipt?) {
        displayData.trip = trip
        displayData.receipt = receipt
    }
    
    func setup(scanResult: ScanResult) {
        displayData.scanResult = scanResult
    }

    func disableFirstResponeder() {
        displayData.needFirstResponder = false
    }
    
    var removeAction: Observable<WBReceipt> {
        return previewRemoveAction.asObservable()
    }
    
    var showAttachmentAction: Observable<WBReceipt> {
        return previewShowAttachmentAction.asObservable()
    }
    
    var manageCategoriesTap: Observable<Void>? {
        return formView?.manageCategoriesTap
    }
    
    var managePaymentMethodsTap: Observable<Void>? {
        return formView?.managePaymentMethodsTap
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditReceiptView {
    var presenter: EditReceiptPresenter {
        return _presenter as! EditReceiptPresenter
    }
    var displayData: EditReceiptDisplayData {
        return _displayData as! EditReceiptDisplayData
    }
}

