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
    
    private let bag = DisposeBag()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorInset = .zero
        setPresentationCellNib(DistanceCell.viewNib())
        
        let notifications = [AppNotificationCenter.syncProvider.asVoid(), AppNotificationCenter.didSyncBackup]
        Observable<Void>.merge(notifications)
            .subscribe(onNext: { [weak self] in
                self?.tableView.reloadData()
            }).disposed(by: bag)
        
        titleLabel.text = LocalizedString("report_info_distance")
        updateSubtitle()
    }
    
    override func createFetchedModelAdapter() -> FetchedModelAdapter? {
        return presenter.fetchedModelAdapter(for: trip!)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
    
    private func updateSubtitle() {
        subtitleLabel.text = nil
        let distances = fetchedItems as! [Distance]
        guard distances.isNotEmpty else { return }
        let totalMileage = distances.reduce(NSDecimalNumber.zero, { result, distance in result.adding(distance.distance)})
        subtitleLabel.text = LocalizedString("total") + ": \(totalMileage)"
    }
    
    override var placeholderTitle: String {
        get { return LocalizedString("distance_no_data") }
    }
    
    override func contentChanged() {
        super.contentChanged()
        presenter.contentChanged.onNext(())
        updateSubtitle()
    }
    
    override func configureCell(cell: UITableViewCell, item: Any) {
        guard let distanceCell = cell as? DistanceCell, let distance = item as? Distance else { return }
        
        dateFormatter.configure(timeZone: distance.timeZone!)
        distanceCell.distanceLabel.text = Price.stringFrom(amount: distance.distance)
        distanceCell.destinationLabel.text = distance.location;
        distanceCell.totalLabel.text = distance.totalRate().mileageRateCurrencyFormattedPrice()
        distanceCell.dateLabel.text = dateFormatter.string(from: distance.date)
        
        let state = ModelSyncState.modelState(modelChangeDate: distance.lastLocalModificationTime)
        distanceCell.setState(state)
    }
    
    override func delete(object: Any!, at indexPath: IndexPath) {
        guard let distance = object as? Distance else { return }
        presenter.delete(distance: distance)
    }
    
    override func tappedObject(_ tapped: Any, indexPath: IndexPath) {
        showEditDistance(with: (trip, tapped as? Distance))
    }
    
    //MARK: Private
    private func showEditDistance(with data: Any?) {
        presenter.presentEditDistance(with: data)
    }
}

extension TripDistancesView: TabHasMainAction {
    func mainAction() {
        showEditDistance(with: (trip, nil as Distance?))
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
