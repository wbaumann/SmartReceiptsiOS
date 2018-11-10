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
    func setup(scan: Scan)
    
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
        formView.apply(scan: displayData.scan)
        formView.settingsTap = presenter.settingsTap
        formView.needFirstResponder = displayData.needFirstResponder
        addChild(formView)
        view.addSubview(formView.view)
        
        configureUIActions()
        configureSubscribers()
        configureTooltip()
        
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
                newTitle = LocalizedString("receipt_dialog_action_edit")
            }
            newTitle = WBPreferences.showReceiptID() ? newTitle + " - \(id!)" : newTitle
            DispatchQueue.main.async { [weak self] in
                self?.title = newTitle
            }
        }
    }
    
    private func configureTooltip() {
        if let text = presenter.tooltipText() {
            var screenWidth = false
            executeFor(iPhone: { screenWidth = true }, iPad: { screenWidth = false })
            tooltip = TooltipView.showOn(view: view, text: text, offset: CGPoint.zero, screenWidth: screenWidth)
            formView.tableView.contentInset = UIEdgeInsets(top: TooltipView.HEIGHT, left: 0, bottom: 0, right: 0)
            
            tooltip?.rx.tap
                .do(onNext: onTooltipClose)
                .bind(to: presenter.tooltipTap)
                .disposed(by: bag)
            
            tooltip?.rx.close
                .do(onNext: onTooltipClose)
                .bind(to: presenter.tooltipClose)
                .disposed(by: bag)
        }
    }
    
    private func onTooltipClose() {
        UIView.animate(withDuration: DEFAULT_ANIMATION_DURATION, animations: {
            self.formView.tableView.contentInset = UIEdgeInsets.zero
        })
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        let removeActionTitle = LocalizedString("receipt_dialog_action_delete")
        let remove = UIPreviewAction(title: removeActionTitle, style: .destructive) { _, _ in
            self.previewRemoveAction.onNext(self.displayData.receipt!)
        }
        
        if let receipt = displayData.receipt, receipt.attachemntType != .none {
            let viewActionTitle = receipt.attachemntType == .image ?
                String(format: LocalizedString("receipt_dialog_action_view"), LocalizedString("image")) :
                String(format: LocalizedString("receipt_dialog_action_view"), LocalizedString("pdf"))
            
            let viewAttachment = UIPreviewAction(title: viewActionTitle, style: .default) { _, _ in
                self.previewShowAttachmentAction.onNext(receipt)
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
    
    func setup(scan: Scan) {
        displayData.scan = scan
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
