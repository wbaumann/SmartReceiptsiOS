//
//  ReceiptsView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import Floaty
import RxSwift

//MARK: - Public Interface Protocol
protocol ReceiptsViewInterface {
    func setup(trip: WBTrip)
    func setup(fetchedModelAdapter: FetchedModelAdapter)
}

//MARK: ReceiptsView Class
final class ReceiptsView: FetchedTableViewController {
    
    static var sharedInputCache = [String: Date]()
    @IBOutlet weak var floatyButton: Floaty!
    
    private static let CELL_ID = "Cell"
    
    private var _imageForCreatorSegue: UIImage!
    private var _receiptForCreatorSegue: WBReceipt!
    private var _priceWidth: CGFloat = 0
    private var tapped: WBReceipt!
    private var dateFormatter = WBDateFormatter()
    private var showReceiptDate = false
    private var showReceiptCategory = false
    private var lastDateSeparator: String!
    private var showAttachmentMarker = false
    
    fileprivate let _titleSubtitleSubject = PublishSubject<TitleSubtitle>()
    
    var receiptsCount: Int { get { return itemsCount } }
    override var placeholderTitle: String { get { return LocalizedString("fetched.placeholder.receipts.title") } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ReceiptsView.sharedInputCache = [String: Date]()
        AppTheme.customizeOnViewDidLoad(self)
        
        showReceiptDate = WBPreferences.layoutShowReceiptDate()
        showReceiptCategory = WBPreferences.layoutShowReceiptCategory()
        showAttachmentMarker = WBPreferences.layoutShowReceiptAttachmentMarker()
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        setPresentationCellNib(ReceiptSummaryCell.viewNib())
        
        updateEditButton()
        updateTitle()
        
        lastDateSeparator = WBPreferences.dateSeparator()
        
        NotificationCenter.default.addObserver(self, selector: #selector(tripUpdated(_:)), name: NSNotification.Name.DatabaseDidUpdateModel, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(settingsSaved), name: NSNotification.Name.SmartReceiptsSettingsSaved, object: nil)
        
        configureFloatyButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTitle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        floatyButton.close()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        updateTitle()
    }
    
    func tripUpdated(_ notification: Notification) {
        if let trip = notification.object as? WBTrip {
            Logger.debug("Updated Trip: \(trip.description)")
        
            if self.trip != trip { return }
        
            //TODO jaanus: check posting already altered object
            self.trip = Database.sharedInstance().tripWithName(self.trip!.name)
            updateTitle()
        }
    }
    
    private func updateTitle() {
        let title = ("\(trip!.formattedPrice()!) - \(trip!.name!)")
        let subtitle = WBPreferences.showReceiptID() ? presenter.nextID() : dailyTotal()
        _titleSubtitleSubject.onNext((title: title, subtitle: subtitle))
    }
    
    
    private func updateEditButton() {
        editButtonItem.isEnabled = itemsCount > 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func dailyTotal() -> String {
        var receipts = fetchedItems as! [WBReceipt]
        let priceCollection = PricesCollection()
        priceCollection.addPrice(Price(currencyCode: WBPreferences.defaultCurrency()))
        if WBPreferences.printDailyDistanceValues() {
            receipts = receipts + presenter.distanceReceipts()
        }
        for receipt in receipts {
            if Calendar.current.isDateInToday(receipt.date) {
                let price = receipt.exchangedPrice() ?? receipt.price()
                priceCollection.addPrice(price)
            }
        }
        return String(format: LocalizedString("trips.controller.daily.total"), priceCollection.currencyFormattedPrice())
    }
    
    private func updatePricesWidth() {
        let w = computePriceWidth()
        if w == _priceWidth { return }
        
        _priceWidth = w
        for cell in tableView.visibleCells as! [ReceiptSummaryCell] {
            cell.priceWidthConstraint.constant = w
            cell.layoutIfNeeded()
        }
    }
    
    private func computePriceWidth() -> CGFloat {
        var maxWidth: CGFloat = 0
        for i in 0..<itemsCount {
            let receipt = objectAtIndexPath(IndexPath(row: i, section: 0)) as! WBReceipt
            let str = receipt.formattedPrice()
            let b = (str as NSString).boundingRect(with: CGSize(width: 1000, height: 100), options: .usesDeviceMetrics, attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 21)], context: nil)
            maxWidth = max(maxWidth, b.width + 10)
        }
        maxWidth = min(maxWidth, view.bounds.width/2)
        return max(view.bounds.width/6, maxWidth)
    }
    
    override func configureCell(row: Int, cell: UITableViewCell, item: Any) {
        let cell = cell as! ReceiptSummaryCell
        let receipt = item as! WBReceipt
        
        cell.priceField.text = receipt.formattedPrice()
        cell.nameField.text = receipt.name
        cell.dateField.text = showReceiptDate ? dateFormatter.formattedDate(receipt.date, in: receipt.timeZone) : ""
        cell.categoryLabel.text = showReceiptCategory ? receipt.category : ""
        cell.markerLabel.text = showAttachmentMarker ? receipt.attachmentMarker() : ""
        cell.priceWidthConstraint.constant = _priceWidth
        cell.layoutIfNeeded()
    }

    override func contentChanged() {
        super.contentChanged()
        updateEditButton()
        updatePricesWidth()
        updateTitle()
    }
    
    override func delete(object: Any!, at indexPath: IndexPath) {
        presenter.receiptDeleteSubject.onNext(object as! WBReceipt)
    }
    
    override func tappedObject(_ tapped: Any, indexPath: IndexPath) {
        self.tapped = tapped as! WBReceipt
        if tableView.isEditing {
            presenter.editReceiptSubject.onNext(self.tapped)
        } else {
            presenter.receiptActionsSubject.onNext(self.tapped)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    override func createFetchedModelAdapter() -> FetchedModelAdapter? {
        return displayData.fetchedModelAdapter
    }
    
    func settingsSaved() {
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
    
    private func configureFloatyButton() {
        addFloatyItem("Text", icon: #imageLiteral(resourceName: "file-text"), subject: presenter.createReceiptTextSubject)
        addFloatyItem("Image", icon: #imageLiteral(resourceName: "camera"), subject: presenter.createReceiptCameraSubject)
    }
    
    private func addFloatyItem(_ title: String?, icon: UIImage, subject: PublishSubject<Void>) {
        let floatyItem = FloatyItem()
        floatyItem.title = title
        floatyItem.buttonColor = AppTheme.primaryDarkColor
        floatyItem.icon = icon
        floatyItem.imageSize = floatyItem.icon!.scaledImageSize(0.75)
        floatyItem.iconImageView.center = floatyItem.center
        floatyItem.handler = { _ in subject.onNext() }
        floatyButton.addItem(item: floatyItem)
    }
}

extension ReceiptsView: TitleSubtitleProtocol {
    var titleSubtitleSubject: PublishSubject<(title: String, subtitle: String?)> {
        return _titleSubtitleSubject
    }
}

extension ReceiptsView: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return navigationController ?? self
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
