//
//  ReceiptsView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift

//MARK: - Public Interface Protocol
protocol ReceiptsViewInterface {
    func setup(trip: WBTrip)
    func setup(fetchedModelAdapter: FetchedModelAdapter)
}

//MARK: ReceiptsView Class
final class ReceiptsView: FetchedTableViewController {
    static var sharedInputCache = [String: Date]()
    
    private static let CELL_ID = "Cell"
    
    private var _imageForCreatorSegue: UIImage!
    private var _receiptForCreatorSegue: WBReceipt!
    private var tapped: WBReceipt!
    private var dateFormatter = WBDateFormatter()
    private var showReceiptDate = false
    private var showReceiptCategory = false
    private var lastDateSeparator: String!
    private var showAttachmentMarker = false
    fileprivate let bag = DisposeBag()
    
    var receiptsCount: Int { get { return itemsCount } }
    override var placeholderTitle: String { get { return LocalizedString("receipt_no_data") } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ReceiptsView.sharedInputCache = [String: Date]()
        AppTheme.customizeOnViewDidLoad(self)
        
        showReceiptDate = WBPreferences.layoutShowReceiptDate()
        showReceiptCategory = WBPreferences.layoutShowReceiptCategory()
        showAttachmentMarker = WBPreferences.layoutShowReceiptAttachmentMarker()
        
        setPresentationCellNib(ReceiptCell.viewNib())
        
        lastDateSeparator = WBPreferences.dateSeparator()
        subscribe()
        
        let notifications = [AppNotificationCenter.syncProvider.asVoid(), AppNotificationCenter.didSyncBackup]
        Observable<Void>.merge(notifications)
            .subscribe(onNext: { [weak self] in
                self?.tableView.reloadData()
            }).disposed(by: bag)
        
        registerForPreviewing(with: self, sourceView: tableView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func tripUpdated(_ notification: Notification) {
        guard let trip = notification.object as? WBTrip, self.trip == trip else { return }
        Logger.debug("Updated Trip: \(trip.description)")
    
        //TODO jaanus: check posting already altered object
        self.trip = Database.sharedInstance().tripWithName(self.trip.name)
        contentChanged()
    }
    
    override func configureCell(row: Int, cell: UITableViewCell, item: Any) {
        let cell = cell as! ReceiptCell
        let receipt = item as! WBReceipt
        cell.configure(receipt: receipt)
        
        
        
        var state: ModelSyncState = .disabled
        if SyncProvider.current != .none {
            if receipt.attachemntType != .none {
                state = receipt.isSynced(syncProvider: .last) ? .synced : .notSynced
            } else {
                state = .modelState(modelChangeDate: receipt.lastLocalModificationTime)
            }
        }
        cell.setState(state)
    }

    override func contentChanged() {
        super.contentChanged()
        presenter.contentChanged.onNext(())
    }
    
    override func delete(object: Any!, at indexPath: IndexPath) {
        presenter.receiptDeleteSubject.onNext(object as! WBReceipt)
    }
    
    override func tappedObject(_ tapped: Any, indexPath: IndexPath) {
        self.tapped = tapped as? WBReceipt
        if tableView.isEditing {
            presenter.editReceiptSubject.onNext(self.tapped)
        } else {
            presenter.receiptActionsSubject.onNext(self.tapped)
        }
    }
    
    override func createFetchedModelAdapter() -> FetchedModelAdapter? {
        return displayData.fetchedModelAdapter
    }
    
    @objc func settingsSaved() {
        if showReceiptDate == WBPreferences.layoutShowReceiptDate()
            && showReceiptCategory == WBPreferences.layoutShowReceiptCategory()
            && showAttachmentMarker == WBPreferences.layoutShowReceiptAttachmentMarker()
            && lastDateSeparator == WBPreferences.dateSeparator() {
            return
        }
        
        lastDateSeparator = WBPreferences.dateSeparator()
        showReceiptDate = WBPreferences.layoutShowReceiptDate()
        showReceiptCategory = WBPreferences.layoutShowReceiptCategory()
        showAttachmentMarker = WBPreferences.layoutShowReceiptAttachmentMarker()
    }
    
    //MARK: Private
    
    private func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(tripUpdated(_:)), name: .DatabaseDidUpdateModel, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(settingsSaved), name: .SmartReceiptsSettingsSaved, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ReceiptsView: TabHasMainAction {
    func mainAction() {
        let sheet = ActionSheet()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet.addAction(title: LocalizedString("receipt_action_camera"), image: #imageLiteral(resourceName: "camera"))
                .bind(to: presenter.createReceiptCameraSubject)
                .disposed(by: bag)
        }
    
        sheet.addAction(title: LocalizedString("receipt_action_text"), image: #imageLiteral(resourceName: "file-text"))
            .bind(to: presenter.createReceiptTextSubject)
            .disposed(by: bag)
        
        sheet.addAction(title: LocalizedString("manual_backup_import"), image: #imageLiteral(resourceName: "file-plus"))
            .debug()
            .bind(to: presenter.importReceiptFileSubject)
            .disposed(by: bag)
        
        sheet.show()
    }
}

//MARK: TooltipApplicable
extension ReceiptsView: TooltipApplicable {
    func viewForTooltip() -> UIView {
        return tableView
    }
}

//MARK: UIDocumentInteractionControllerDelegate
extension ReceiptsView: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return navigationController ?? self
    }
}

//MARK: UIViewControllerPreviewingDelegate
extension ReceiptsView: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        present(UINavigationController(rootViewController: viewControllerToCommit), animated: true, completion: nil)
        viewControllerToCommit.interface(EditReceiptModuleInterface.self)?.makeNameFirstResponder()
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil}
        let receipt = objectAtIndexPath(indexPath) as! WBReceipt
        
        let module = AppModules.editReceipt.build()
        let data = (trip: trip!, receipt: receipt)
        module.presenter.setupView(data: data)
        
        let previewInterface = module.interface(EditReceiptModuleInterface.self)
        previewInterface.disableFirstResponder()
        
        previewInterface.removeAction
            .bind(to: presenter.receiptDeleteSubject)
            .disposed(by: bag)
        
        previewInterface
            .showAttachmentAction.subscribe(onNext: { [unowned self] receipt in
                self.presenter.presentAttachment(for: receipt)
            }).disposed(by: bag)
        
        return module.view
    }
    
}

//MARK: - Public interface
extension ReceiptsView: ReceiptsViewInterface {
    func setup(trip: WBTrip) {
        self.trip = trip
    }
    
    func setup(fetchedModelAdapter: FetchedModelAdapter) {
        displayData.fetchedModelAdapter = fetchedModelAdapter
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptsView {
    var presenter: ReceiptsPresenter {
        return _presenter as! ReceiptsPresenter
    }
    var displayData: ReceiptsDisplayData {
        return _displayData as! ReceiptsDisplayData
    }
}
