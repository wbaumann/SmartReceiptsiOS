//
//  TripDistancesView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxSwift
import RxCocoa

//MARK: - Public Interface Protocol
protocol TripDistancesViewInterface {
    func setup(trip: WBTrip)
}

//MARK: TripDistances View
class TripDistancesView: FetchedTableViewController {
    
    private let dateFormatter = DateFormatter()
    private var maxRateWidth: CGFloat = 0
    
    private let bag = DisposeBag()
    
    @IBOutlet private var addButton: UIButton?
    @IBOutlet private var doneButtonItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalizedString("distances.controller.title")
        setPresentationCellNib(DistanceCell.viewNib())
        configureUIActions()
    }
    
    override func createFetchedModelAdapter() -> FetchedModelAdapter? {
        return presenter.fetchedModelAdapter(for: trip!)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    func findMaxRateWidth() -> CGFloat {
        var max: CGFloat = 0
        for row in 0..<itemsCount {
            if let distance = objectAtIndexPath(IndexPath(row: row, section: 0)) as? Distance {
                let distanceString = Price.stringFrom(amount: distance.distance)
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
        super.contentChanged()
        maxRateWidth = findMaxRateWidth()
        for cell in tableView.visibleCells {
            if let dsCell = cell as? DistanceCell {
                dsCell.setPriceLabelWidth(maxRateWidth)
            }
        }
        presenter.contentChanged.onNext()
    }
    
    override func configureCell(row: Int, cell: UITableViewCell, item: Any) {
        if let distanceCell = cell as? DistanceCell {
            if let distance = item as? Distance {
                dateFormatter.configure(timeZone: distance.timeZone!)
                distanceCell.distanceLabel.text = Price.stringFrom(amount: distance.distance)
                distanceCell.destinationLabel.text = distance.location;
                distanceCell.totalLabel.text = distance.totalRate().mileageRateCurrencyFormattedPrice()
                distanceCell.dateLabel.text = dateFormatter.string(from: distance.date)
                distanceCell.setPriceLabelWidth(maxRateWidth)
                
                let state = ModelSyncState.modelState(modelChangeDate: distance.lastLocalModificationTime)
                distanceCell.setState(state)
            }
        }
    }
    
    override func delete(object: Any!, at indexPath: IndexPath) {
        if let distance = object as? Distance {
            presenter.delete(distance: distance)
        }
    }
    
    override func tappedObject(_ tapped: Any, indexPath: IndexPath) {
        showEditDistance(with: (trip, tapped as? Distance))
    }
    
    //MARK: Actions
    private func configureUIActions() {
        doneButtonItem?.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: bag)
        
        addButton?.rx.tap.subscribe(onNext: { [weak self] in
            self?.showEditDistance(with: (self?.trip, nil as Distance?))
        }).disposed(by: bag)
        
    }
    
    //MARK: Private
    private func showEditDistance(with data: Any?) {
        presenter.presentEditDistance(with: data)
    }
}

//MARK: - Public interface
extension TripDistancesView: TripDistancesViewInterface {
    
    func setup(trip: WBTrip) {
        self.trip = trip
    }
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
