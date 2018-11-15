//
//  TripsView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift
import RxCocoa

//MARK: - Public Interface Protocol
protocol TripsViewInterface {
    var settingsTap: Observable<Void> { get }
    var autoScansTap: Observable<Void> { get }
    var backupTap: Observable<Void> { get }
    var userGuideTap: Observable<Void> { get }
    var privacyTap: Observable<Void> { get }
    var addButton: UIButton { get }
    var debugButton: UIBarButtonItem { get }
}

//MARK: Trips View
final class TripsView: FetchedTableViewController {
    
    @IBOutlet fileprivate weak var menuButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var _debugButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var _addButton: UIButton!
    @IBOutlet fileprivate weak var editItem: UIBarButtonItem!
    
    fileprivate let privacySubject = PublishSubject<Void>()
    
    private var priceWidth: CGFloat = 0
    private let dateFormatter = WBDateFormatter()
    private var lastDateSeparator: String!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppTheme.customizeOnViewDidLoad(self)
        lastDateSeparator = WBPreferences.dateSeparator()
        setPresentationCellNib(TripCell.viewNib())
        navigationController?.setToolbarHidden(true, animated: false)
        title = PurchaseService.hasValidSubscriptionValue ? AppTheme.appTitlePlus : AppTheme.appTitle
        
        configurePrivacyTooltip()
        configureDebug()
        configureRx()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureRx() {
        Observable<Void>.merge(AppNotificationCenter.syncProvider.asVoid(), AppNotificationCenter.didSyncBackup)
            .subscribe {
                self.tableView.reloadData()
            }.disposed(by: bag)
        
        NotificationCenter.default.rx.notification(.SmartReceiptsSettingsSaved)
            .subscribe { [weak self] _ in
                self?.settingsSaved()
            }.disposed(by: bag)
        
        NotificationCenter.default.rx.notification(.SmartReceiptsAdsRemoved)
            .subscribe { [weak self] _ in
                self?.title = AppTheme.appTitlePlus
            }.disposed(by: bag)
        
        NotificationCenter.default.rx.notification(.SmartReceiptsImport)
            .subscribe { [weak self] _ in
                self?.fetchObjects()
            }.disposed(by: bag)
        
        editItem.rx.tap.subscribe { [unowned self] in
            self.setEditing(!self.isEditing, animated: true)
        }.disposed(by: bag)
    }
    
    private func configureDebug() {
        #if DEBUG
            _debugButton.title = "DEBUG"
        #else
            _debugButton.title = ""
            _debugButton.isEnabled = false
        #endif
    }
    
    func configurePrivacyTooltip() {
        guard let tooltip = TooltipService.shared.tooltipText(for: .trips) else { return }
        let tooltipView = TooltipView.showOn(view: view, text: tooltip)
        tableView.contentInset = UIEdgeInsets(top: TooltipView.HEIGHT, left: 0, bottom: 0, right: 0)

        weak var weakTable = tableView
        tooltipView.rx.tap
            .do(onNext: {
                TooltipService.shared.markPrivacyOpened()
                weakTable?.contentInset = UIEdgeInsets.zero
            }).bind(to: privacySubject)
            .disposed(by: bag)
        
        tooltipView.rx.close
            .subscribe(onNext: {
                TooltipService.shared.markPrivacyDismissed()
                weakTable?.contentInset = UIEdgeInsets.zero
            }).disposed(by: bag)
    }
    
    @IBAction private func menuTap() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for action in displayData.makeActions() {
            actionSheet.addAction(action)
        }
        
        if let popoverController = actionSheet.popoverPresentationController {
            let arrowMargin = UI_MARGIN_16 + 20
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: arrowMargin, y: -UI_MARGIN_16, width: 0, height: 0)
            popoverController.permittedArrowDirections = .up
        } else {
            actionSheet.addAction(UIAlertAction(title: LocalizedString("DIALOG_CANCEL"), style: .cancel, handler: nil))
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func settingsSaved() {
        if lastDateSeparator == WBPreferences.dateSeparator() { return }
        lastDateSeparator = WBPreferences.dateSeparator()
        tableView.reloadData()
    }
    
    override var placeholderTitle: String {
        get { return LocalizedString("trip_no_data") }
    }

    override func createFetchedModelAdapter() -> FetchedModelAdapter? {
        return presenter.fetchedModelAdapter()
    }
    
    private func updatePricesWidth() {
        let w = computePriceWidth()
        if w == priceWidth {
            return
        }
        priceWidth = w
        for cell in tableView.visibleCells {
            if let pCell = cell as? TripCell {
                pCell.priceWidthConstraint.constant = w
                pCell.layoutIfNeeded()
            }
        }
    }
    
    private func computePriceWidth() -> CGFloat {
        var maxWidth: CGFloat = 0
        
        for i in 0..<itemsCount {
            let trip = objectAtIndexPath(IndexPath(row: i, section: 0)) as! WBTrip
            var formattedPrice = trip.formattedPrice()
            
            // Victor:
            // In some cases WBTrip.pricesSummary becomes nil (say, when we removed any trip in this VC), actually it has been re-initialized without refresing 'pricesSummary'
            // lines below solving the problem without breaking something else (as I afraid to do so)
            if formattedPrice == nil {
                Database.sharedInstance().refreshPriceForTrip(trip)
                formattedPrice = trip.formattedPrice()
            }
            let b = (formattedPrice! as NSString).boundingRect(with: CGSize(width: 1000, height: 100),
                options: .usesDeviceMetrics, attributes: [.font : UIFont.boldSystemFont(ofSize: 21)], context: nil)
            maxWidth = max(maxWidth, b.width + 10)
        }
        
        let priceLabelSpacing: CGFloat = 16
        let priceToNameSpacing: CGFloat = 12
        
        return min((view.bounds.width - priceLabelSpacing * 2 - priceToNameSpacing)/2, maxWidth)
    }
    
    override func configureCell(row: Int, cell: UITableViewCell, item: Any) {
        let pCell = cell as! TripCell
        let trip = item as! WBTrip
        
        pCell.priceLabel.text = trip.formattedPrice()
        pCell.nameLabel.text = trip.name
        pCell.dateLabel.text = String(format: LocalizedString("trip_adapter_list_item_to"),
                                      dateFormatter.formattedDate(trip.startDate, in: trip.startTimeZone),
                                      dateFormatter.formattedDate(trip.endDate, in: trip.endTimeZone))
        pCell.priceWidthConstraint.constant = priceWidth
        pCell.layoutIfNeeded()
        
        let state = ModelSyncState.modelState(modelChangeDate: trip.lastLocalModificationTime)
        pCell.setState(state)
    }
    
    
    override func configureSubrcibers(for adapter: FetchedModelAdapter?) {
        super.configureSubrcibers(for: adapter)
        guard let fetchedModelAdapter = adapter else { return }
        
        fetchedModelAdapter.rx.didInsert.subscribe(onNext: { [unowned self] action in
            self.presenter.tripDetailsSubject.onNext(action.object as! WBTrip)
        }).disposed(by: bag)
    }
    
    override func delete(object: Any!, at indexPath: IndexPath) {
        presenter.tripDeleteSubject.onNext(object as! WBTrip)
    }
    
    override func tappedObject(_ tapped: Any, indexPath: IndexPath) {
        let trip = tapped as! WBTrip
        isEditing ? presenter.tripEditSubject.onNext(trip) : presenter.tripDetailsSubject.onNext(trip)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DEFAULT_ANIMATION_DURATION) {
            self.tableView.reloadData()
        }
    }
    
    override func contentChanged() {
        super.contentChanged()
        updatePricesWidth()
    }
}

//MARK: - Public interface
extension TripsView: TripsViewInterface {
    var settingsTap: Observable<Void> { return  displayData.settingsTap }
    var autoScansTap: Observable<Void> { return  displayData.autoScansTap }
    var backupTap: Observable<Void> { return  displayData.backupTap }
    var userGuideTap: Observable<Void> { return  displayData.userGuideTap }
    var privacyTap: Observable<Void> { return privacySubject }
    var debugButton: UIBarButtonItem { return _debugButton }
    var addButton: UIButton { return _addButton }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripsView {
    var presenter: TripsPresenter {
        return _presenter as! TripsPresenter
    }
    var displayData: TripsDisplayData {
        return _displayData as! TripsDisplayData
    }
}
