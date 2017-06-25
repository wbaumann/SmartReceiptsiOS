//
//  ReceiptsView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit

//MARK: - Public Interface Protocol
protocol ReceiptsViewInterface {
    func setup(trip: WBTrip)
    func setup(fetchedModelAdapter: FetchedModelAdapter)
    var createReceiptButton: UIBarButtonItem { get }
    var createPhotoReceiptButton: UIBarButtonItem { get }
    var distancesButton: UIBarButtonItem { get }
    var generateReportButton: UIBarButtonItem { get }
}

//MARK: ReceiptsView Class
final class ReceiptsView: FetchedCollectionViewControllerSwift {
    
    static var sharedInputCache = [Date]()
    
    @IBOutlet weak var distanceButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var createButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    private static let CellIdentifier = "Cell"
    private static let PresentTripDistancesSegue = "PresentTripDistancesSegue"
    
    private var _imageForCreatorSegue: UIImage!
    private var _receiptForCreatorSegue: WBReceipt!
    private var _priceWidth: CGFloat = 0
    private var tapped: WBReceipt!
    private var dateFormatter = WBDateFormatter()
    private var showReceiptDate = false
    private var showReceiptCategory = false
    private var lastDateSeparator: String!
    private var showAttachmentMarker = false
    
    var receiptsCount: Int { get{ return numberOfItems() } }
    override var placeholderTitle: String { get { return LocalizedString("fetched.placeholder.receipts.title") } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ReceiptsView.sharedInputCache = [Date]()
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
    }
    
    func tripUpdated(_ notification: Notification) {
        if let trip = notification.object as? WBTrip {
            Logger.debug("Updated Trip: \(trip.description)")
        
            if self.trip != trip { return }
        
            //TODO jaanus: check posting already altered object
            self.trip = Database.sharedInstance().tripWithName(self.trip!.name)
            self.updateTitle()
        }
    }
    
    private func updateTitle() {
        Logger.debug("Update Title")
        let title = ("\(trip!.formattedPrice()!) - \(trip!.name!)")
        let subtitle = WBPreferences.showReceiptID() ? nextID() : dailyTotal();
        setTitle(title, subtitle: subtitle, color: UIColor.white)
    }
    
    
    private func updateEditButton() {
        editButtonItem.isEnabled = numberOfItems() > 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func dailyTotal() -> String {
        var receipts = self.allObjects() as? [WBReceipt] ?? [WBReceipt]()
        let priceCollection = PricesCollection()
        priceCollection.addPrice(Price.zeroPrice(withCurrencyCode: WBPreferences.defaultCurrency()))
        if WBPreferences.printDailyDistanceValues() {
            receipts = receipts + distanceReceipts()
        }
        for receipt in receipts {
            if Calendar.current.isDateInToday(receipt.date) {
                let price = receipt.exchangedPrice() ?? receipt.price()
                priceCollection.addPrice(price)
            }
        }
        return String(format: LocalizedString("trips.controller.daily.total"), priceCollection.currencyFormattedPrice())
    }
    
    private func distanceReceipts() -> [WBReceipt] {
        let distances = Database.sharedInstance().fetchedAdapterForDistances(in: trip!, ascending: true)
        return DistancesToReceiptsConverter.convertDistances(distances!.allObjects()) as! [WBReceipt]
    }
    
    private func nextID() -> String {
        let id = Database.sharedInstance().nextAutoGeneratedID(forTable: ReceiptsTable.Name)
        return String(format: LocalizedString("trips.controller.next.id.subtitle"), "\(id)")
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
        for i in 0..<numberOfItems() {
            let receipt = objectAtIndexPath(IndexPath(row: i, section: 0)) as! WBReceipt
            let str = receipt.formattedPrice()
            let b = (str as NSString).boundingRect(with: CGSize(width: 1000, height: 100), options: .usesDeviceMetrics, attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 21)], context: nil)
            maxWidth = max(maxWidth, b.width + 10)
        }
        maxWidth = min(maxWidth, view.bounds.width/2)
        return max(view.bounds.width/6, maxWidth)
    }
    
    override func configureCell(_ cell: UITableViewCell, indexPath: IndexPath, object: Any) {
        let cell = cell as! ReceiptSummaryCell
        let receipt = object as! WBReceipt
        
        cell.priceField.text = receipt.formattedPrice()
        cell.nameField.text = receipt.name
        cell.dateField.text = showReceiptDate ? dateFormatter.formattedDate(receipt.date, in: receipt.timeZone) : ""
        cell.categoryLabel.text = showReceiptCategory ? receipt.category : ""
        cell.markerLabel.text = showAttachmentMarker ? receipt.attachmentMarker() : ""
        cell.priceWidthConstraint.constant = _priceWidth
    }

    override func contentChanged() {
        updateEditButton()
        updatePricesWidth()
        updateTitle()
    }
    
    override func delete(object: Any!, at indexPath: IndexPath) {
        AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuDelete())
        Database.sharedInstance().delete(object as! WBReceipt)
    }
    
    func attachPdfOrImageFile(_ pdfFile: String, toReceipt: WBReceipt) -> Bool {
        let ext = (pdfFile as NSString).pathExtension
        
        let imageFileName = String(format: "%tu_%@.%@", toReceipt.receiptId(), toReceipt.name, ext)
        let newFile = trip?.file(inDirectoryPath: imageFileName)
        
        if !WBFileManager.forceCopy(from: pdfFile, to: newFile) {
            Logger.error("Couldn't force copy from \(pdfFile) to \(newFile!)")
            return false
        }
        
        if !Database.sharedInstance().update(toReceipt, changeFileNameTo: imageFileName) {
            Logger.error("Error: cannot update image file \(imageFileName) for receipt \(toReceipt.name)")
            return false
        }
        return true
    }
    
    func update(receipt: WBReceipt, image: UIImage?) -> Bool {
        var imageFileName = ""
        if image != nil {
            imageFileName = String(format: "%tu_%@.jpg", receipt.receiptId(), receipt.name)
            let path = trip!.file(inDirectoryPath: imageFileName)
            if !WBFileManager.forceWrite(UIImageJPEGRepresentation(image!, 0.85), to: path!) {
                imageFileName = ""
            }
            
            if imageFileName.isEmpty {
                return false
            }
            
            if !Database.sharedInstance().update(receipt, changeFileNameTo: imageFileName) {
                Logger.error("Error: cannot update image file")
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    override func tappedObject(_ tapped: Any, indexPath: IndexPath) {
        self.tapped = tapped as! WBReceipt
        if tableView.isEditing {
            presenter.editReceiptSubject.onNext(self.tapped)
        } else {
            presenter.receiptActionsSubject.onNext(self.tapped)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ReceiptActions") {
            let vc = segue.destination as! WBReceiptActionsViewController
            vc.receiptsViewController = self
            vc.receipt = tapped
        } else if segue.identifier == "ReceiptCreator" {
            
            let vc = segue.destination as! EditReceiptViewController
            vc.receiptsViewController = self
            var receipt: WBReceipt!
            if self.tapped != nil {
                receipt = tapped
                AnalyticsManager.sharedManager.record(event: Event.receiptsReceiptMenuEdit())
            } else {
                if _imageForCreatorSegue != nil {
                    AnalyticsManager.sharedManager.record(event: Event.receiptsAddPictureReceipt())
                    vc.receiptImage = _imageForCreatorSegue!
                } else {
                    AnalyticsManager.sharedManager.record(event: Event.receiptsAddTextReceipt())
                }
                receipt = _receiptForCreatorSegue
                _receiptForCreatorSegue = nil
                _imageForCreatorSegue = nil
            }
            vc.setReceipt(receipt, with: trip!)
        }
        tapped = nil
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
        tableView.reloadData()
    }
}

extension ReceiptsView: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return navigationController ?? self
    }
}

//MARK: - Public interface
extension ReceiptsView: ReceiptsViewInterface {
    var createReceiptButton: UIBarButtonItem { get { return createButton } }
    var createPhotoReceiptButton: UIBarButtonItem { get { return cameraButton } }
    var distancesButton: UIBarButtonItem { get { return distanceButton } }
    var generateReportButton: UIBarButtonItem { get { return shareButton } }
    
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
