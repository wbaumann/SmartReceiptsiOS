//
//  TripsView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit

//MARK: - Public Interface Protocol
protocol TripsViewInterface {
    
}

//MARK: Trips View
final class TripsView: FetchedCollectionViewControllerSwift {
    
    var tapped: WBTrip!
    private var priceWidth: CGFloat = 0
    private let dateFormatter = WBDateFormatter()
    private(set) var lastShowTrip: WBTrip?
    private var lastDateSeparator: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppTheme.customizeOnViewDidLoad(self)
        setPresentationCellNib(WBCellWithPriceNameDate.viewNib())
        NotificationCenter.default.addObserver(self, selector: #selector(settingsSaved),
                        name: NSNotification.Name.SmartReceiptsSettingsSaved, object: nil)
        lastDateSeparator = WBPreferences.dateSeparator()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func settingsSaved() {
        if lastDateSeparator == WBPreferences.dateSeparator() {
            return
        }
        lastDateSeparator = WBPreferences.dateSeparator()
        tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateEditButton()
    }
    
    func updateEditButton() {
        editButtonItem.isEnabled = numberOfItems() > 0
    }
    
    override var placeholderTitle: String {
        get { return LocalizedString("fetched.placeholder.trips.title") }
    }

    override func createFetchedModelAdapter() -> FetchedModelAdapter? {
        return Database.sharedInstance().createUpdatingAdapterForAllTrips()
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
        
        for i in 0..<numberOfItems() {
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
    
    
    override func configureCell(_ cell: UITableViewCell, indexPath: IndexPath, object: Any) {
        let pCell = cell as! WBCellWithPriceNameDate
        let trip = object as! WBTrip
        
        pCell.priceField.text = trip.formattedPrice()
        pCell.nameField.text = trip.name
        pCell.dateField.text = String(format: LocalizedString("trips.controller.from.to.date.label.base"),
            dateFormatter.formattedDate(trip.startDate, in: trip.startTimeZone),
            dateFormatter.formattedDate(trip.endDate, in: trip.endTimeZone))
        pCell.priceWidthConstraint.constant = priceWidth
    }
    
    override func delete(object: Any!, at indexPath: IndexPath) {
        Database.sharedInstance().delete(object as! WBTrip)
    }
    
    override func tappedObject(_ tapped: Any, indexPath: IndexPath) {
       self.tapped = tapped as! WBTrip
        if isEditing {
            //TODO: SHOW TRIP CREATOR
            self.performSegue(withIdentifier: "TripCreator", sender: self)
        } else {
            //TODO: SHOW TRIP DETAILS
            self.performSegue(withIdentifier: "TripDetails", sender: self)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TripDetails" {
            let vc = segue.destination as! WBReceiptsViewController
            vc.trip = tapped
            lastShowTrip = tapped
        } else if segue.identifier == "TripCreator" {
            let vc = segue.destination as! EditTripViewController
            vc.trip = tapped
        }
        tapped = nil
    }
    
    override func contentChanged() {
        updatePricesWidth()
        updateEditButton()
    }
    
    override func didInsert(_ object: Any!, at index: UInt) {
        super.didInsert(object, at: index)
        tapped = object as! WBTrip
        performSegue(withIdentifier: "TripDetails", sender: nil)
    }
    
    @IBAction private func onAddTap() {
        isEditing = false
        performSegue(withIdentifier: "TripCreator", sender: nil)
    }
    
    @IBAction private func onSettingsTap() {
        let settingsVC = MainStoryboard().instantiateViewController(withIdentifier: "SettingsOverflow")
        settingsVC.modalTransitionStyle = .crossDissolve
        settingsVC.modalPresentationStyle = .formSheet
        present(settingsVC, animated: true, completion: nil)
    }
    
}

extension TripsView: UISplitViewControllerDelegate {

}

//MARK: - Public interface
extension TripsView: TripsViewInterface {
    
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
