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
import MKDropdownMenu

//MARK: - Public Interface Protocol
protocol TripsViewInterface {
    var settingsTap: Observable<Void> { get }
    var autoScansTap: Observable<Void> { get }
    var addButton: UIButton { get }
    var debugButton: UIBarButtonItem { get }
}

//MARK: Trips View
final class TripsView: FetchedTableViewController {
    
    @IBOutlet fileprivate weak var menuButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var _debugButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var _addButton: UIButton!
    @IBOutlet fileprivate weak var editItem: UIBarButtonItem!
    
    private var priceWidth: CGFloat = 0
    private let dateFormatter = WBDateFormatter()
    private var lastDateSeparator: String!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppTheme.customizeOnViewDidLoad(self)
        setPresentationCellNib(WBCellWithPriceNameDate.viewNib())
        navigationController?.setToolbarHidden(true, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(settingsSaved),
                        name: NSNotification.Name.SmartReceiptsSettingsSaved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchObjects),
                        name: NSNotification.Name.SmartReceiptsImport, object: nil)
        
        lastDateSeparator = WBPreferences.dateSeparator()
        
        editItem.rx.tap.subscribe(onNext: { [unowned self] in
            self.setEditing(!self.isEditing, animated: true)
        }).disposed(by: bag)
        
        configureDebug()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = AppTheme.appTitle
        //configureMenu()
        view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        title = String()
    }
    
    private func configureDebug() {
        #if DEBUG
            _debugButton.title = "DEBUG"
        #else
            _debugButton.title = ""
            _debugButton.isEnabled = false
        #endif
    }
    
    private func configureMenu() {
        let menuIcon = #imageLiteral(resourceName: "more-horizontal")
        let menu = MKDropdownMenu(frame: CGRect(x: 0, y: 0, width: 30, height: TOUCH_AREA))
        let menuWidth: CGFloat = 230
        menuButton.customView = menu
        
        menu.tintColor = .white
        menu.delegate = displayData.menuDisplayData
        menu.dataSource = displayData.menuDisplayData
        menu.disclosureIndicatorImage = menuIcon
        menu.disclosureIndicatorSelectionRotation = 0
        menu.dropdownBouncesScroll = false
        menu.useFullScreenWidth = true
        menu.fullScreenInsetLeft = 8
        menu.fullScreenInsetRight = UIScreen.main.bounds.width - menuWidth
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
            actionSheet.addAction(UIAlertAction(title: LocalizedString("general_title_cancel"), style: .cancel, handler: nil))
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func settingsSaved() {
        if lastDateSeparator == WBPreferences.dateSeparator() {
            return
        }
        lastDateSeparator = WBPreferences.dateSeparator()
        tableView.reloadData()
    }
    
    override var placeholderTitle: String {
        get { return LocalizedString("fetched.placeholder.trips.title") }
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
            if let pCell = cell as? WBCellWithPriceNameDate {
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
                options: .usesDeviceMetrics, attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 21)], context: nil)
            maxWidth = max(maxWidth, b.width + 10)
        }
        
        let priceLabelSpacing: CGFloat = 16
        let priceToNameSpacing: CGFloat = 12
        
        return min((view.bounds.width - priceLabelSpacing * 2 - priceToNameSpacing)/2, maxWidth)
    }
    
    override func configureCell(row: Int, cell: UITableViewCell, item: Any) {
        let pCell = cell as! WBCellWithPriceNameDate
        let trip = item as! WBTrip
        
        pCell.priceField.text = trip.formattedPrice()
        pCell.nameField.text = trip.name
        pCell.dateField.text = String(format: LocalizedString("trips.controller.from.to.date.label.base"),
                                      dateFormatter.formattedDate(trip.startDate, in: trip.startTimeZone),
                                      dateFormatter.formattedDate(trip.endDate, in: trip.endTimeZone))
        pCell.priceWidthConstraint.constant = priceWidth
        pCell.layoutIfNeeded()
    }
    
    
    override func configureSubrcibers(for adapter: FetchedModelAdapter?) {
        super.configureSubrcibers(for: adapter)
        guard let fetchedModelAdapter = adapter else { return }
        
        fetchedModelAdapter.rx.didInsert.subscribe(onNext: { [unowned self] action in
            self.presenter.tripDetailsSubject.onNext(action.object as! WBTrip)
        }).addDisposableTo(bag)
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

extension TripsView: UISplitViewControllerDelegate {

}

//MARK: - Public interface
extension TripsView: TripsViewInterface {
    var settingsTap: Observable<Void> { return  displayData.settingsTap }
    var autoScansTap: Observable<Void> { return  displayData.autoScansTap }
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
