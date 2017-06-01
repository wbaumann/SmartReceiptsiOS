//
//  TripDistancesView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit

fileprivate let PushDistanceAddViewControllerSegue = "PushDistanceAddViewControllerSegue"

//MARK: - Public Interface Protocol
protocol TripDistancesViewInterface {
    
}

//MARK: TripDistances View
class TripDistancesView: FetchedCollectionViewControllerSwift {
    
    let dateFormatter = WBDateFormatter()
    var maxRateWidth: CGFloat = 0
    var tapped: Distance?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalizedString("distances.controller.title")
        setPresentationCellNib(DistanceSummaryCell.viewNib())
    }
    
    override func createFetchedModelAdapter() -> FetchedModelAdapter? {
        return Database.sharedInstance().fetchedAdapterForDistances(in: trip)
    }
    
    override func delete(object: Any!, at indexPath: IndexPath) {
        if let distance = object as? Distance {
            Database.sharedInstance().delete(distance)
        }
    }
    
    override func tappedObject(_ tapped: Any, indexPath: IndexPath) {
        performSegue(withIdentifier: PushDistanceAddViewControllerSegue, sender: nil)
    }
    
    func findMaxRateWidth() -> CGFloat {
        var max: CGFloat = 0
        for row in 0..<numberOfItems() {
            if let distance = objectAtIndexPath(IndexPath(row: row, section: 0)) as? Distance {
                let distanceString = Price.amount(asString: distance.distance)
                let bounds = distanceString.boundingRect(with: CGSize(width: 1000, height: 100), options: .usesDeviceMetrics,
                 attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 21)], context: nil)
                
                max = CGFloat.maximum(max, bounds.width + 10)
            }
        }
        return max
    }
    
    override var placeholderTitle: String {
        get { return LocalizedString("fetched.placeholder.distances.title") }
    }
    
    override func contentChanged() {
        maxRateWidth = findMaxRateWidth()
        for cell in tableView.visibleCells {
            if let dsCell = cell as? DistanceSummaryCell {
                dsCell.setPriceLabelWidth(maxRateWidth)
            }
        }
    }
    
    override func configureCell(_ cell: UITableViewCell, indexPath: IndexPath, object: Any) {
        if let summaryCell = cell as? DistanceSummaryCell {
            if let distance = object as? Distance {
                summaryCell.distanceLabel.text = Price.amount(asString: distance.distance)
                summaryCell.destinationLabel.text = distance.location;
                summaryCell.totalLabel.text = distance.totalRate().mileageRateCurrencyFormattedPrice()
                summaryCell.dateLabel.text = dateFormatter.formattedDate(distance.date, in: distance.timeZone)
                summaryCell.setPriceLabelWidth(maxRateWidth)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (PushDistanceAddViewControllerSegue == segue.identifier) {
            let editViewController = segue.destination as? EditDistanceViewController
            editViewController?.trip = trip
            editViewController?.distance = tapped
            tapped = nil
        }
    
    }
    
    //MARK: Actions
    @IBAction func onDoneTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddTap() {
        
    }
}

//MARK: - Public interface
extension TripDistancesView: TripDistancesViewInterface {
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension TripDistancesView {
    var presenter: TripDistancesPresenter {
        return _presenter as! TripDistancesPresenter
    }
    var displayData: TripDistancesDisplayData {
        return _displayData as! TripDistancesDisplayData
    }
}
        

            

