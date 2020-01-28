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
        tableView.delegate = self
        tableView.register(headerFooter: ReceiptsSectionHeader.self)
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
        reloadHeaders()
        updateSubtitle()
    }
    
    override func configureCell(cell: UITableViewCell, item: Any) {
        guard let distanceCell = cell as? DistanceCell, let distance = item as? Distance else { return }
        dateFormatter.configure(timeZone: distance.timeZone!)
        distanceCell.configure(distance: distance)
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
    
    override var dataSourceType: TableType {
        return .sections
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

extension TripDistancesView {
    func reloadHeaders() {
        let visibleSections = Set(tableView.indexPathsForVisibleRows?.compactMap { $0.section } ?? [])
        visibleSections.forEach { section in
            guard let header = tableView.headerView(forSection: section) as? ReceiptsSectionHeader else { return }
           configure(header: header, section: section)
        }
    }

    func price(section: Int) -> String {
       let first = dataSource.object(at: IndexPath(row: 0, section: section)) as! Distance
       let price = fetchedItems
           .map { $0 as! Distance }
           .filter { $0.sectionDate == first.sectionDate }
           .reduce(PricesCollection(), { result, distance in
               result.addPrice(distance.totalRate())
               return result
           }).currencyFormattedTotalPrice()
       
       return price.isEmpty ? Price(currencyCode: first.trip.defaultCurrency.code).currencyFormattedPrice() : price
    }

    private func configure(header: ReceiptsSectionHeader, section: Int) {
       guard let title = dataSource.tableView(tableView, titleForHeaderInSection: section) else { return }
       _ = header.configure(title: title, subtitle: price(section: section))
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       guard let title = dataSource.tableView(tableView, titleForHeaderInSection: section) else { return UIView(frame: .zero) }
       let header = tableView.dequeueHeaderFooter(headerFooter: ReceiptsSectionHeader.self)
       return header.configure(title: title, subtitle: price(section: section))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constatns.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(Float.ulpOfOne)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
    
    private enum Constatns {
        static let headerHeight: CGFloat = 54
        
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
