//
//  FetchedTableViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 10/08/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Viperit

@objcMembers
class FetchedTableViewController: UserInterface {
    
    @IBOutlet var tableView: UITableView!
    
    private let FETCHED_COLLECTION_CELL_ID = "FetchedCollectionTableViewControllerCellIdentifier"
    private var bag = DisposeBag()
    private var fetchedModelAdapter: FetchedModelAdapter?
    private(set) var dataSource: FetchedTableViewDataSource!
    
    private(set) var placeholderTitle = ""
    
    var trip: WBTrip!
    var placeholderView: FetchedPlaceholderView?
    var itemsCount: Int { return fetchedModelAdapter?.allObjects().count ?? 0 }
    var fetchedItems: [Any] { return fetchedModelAdapter?.allObjects() ?? [Any]() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        dataSource = createDataSource()
        dataSource.deleteRow = { [weak self] indexPath in
            let model = self?.objectAtIndexPath(indexPath)
            self?.delete(object: model!, at: indexPath)
        }
    }
    
    private func createDataSource() -> FetchedTableViewDataSource {
        switch dataSourceType {
        case .plain:
            return FetchedTableViewDataSource.init(
                tableView: tableView,
                cellId: FETCHED_COLLECTION_CELL_ID,
                configureCell: { [unowned self] cell, item in
                    self.configureCell( cell: cell, item: item)
                }
            )
        case .sections:
            return DateSectionedTableViewDataSource.init(
                tableView: tableView,
                cellId: FETCHED_COLLECTION_CELL_ID,
                configureCell: { [unowned self] cell, item in
                    self.configureCell( cell: cell, item: item)
                }
            )
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        placeholderView?.frame = view.bounds
        UIView.animate(withDuration: DEFAULT_ANIMATION_DURATION) {
            self.view.layoutIfNeeded()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchedModelAdapter == nil ? fetchObjects() : ()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    private func configureTable() {
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    func setPresentationCellNib(_ nib: UINib) {
        tableView.register(nib, forCellReuseIdentifier: FETCHED_COLLECTION_CELL_ID)
    }
    
    var dataSourceType: TableType {
        return .plain
    }
    
    func configureCell(cell: UITableViewCell, item: Any) {
        Logger.debug("LOGGER_DEBUG(configureCell:for \(item)")
    }
    
    //MARK: Placeholder
    
    func checkNeedsPlaceholder() {
        if fetchedModelAdapter != nil {
            itemsCount > 0 ? hidePlaceholder() : showPlaceholder()
        } else {
            showPlaceholder()
        }
    }
    
    func hidePlaceholder() {
        placeholderView?.removeFromSuperview()
        placeholderView = nil
    }
    
    func showPlaceholder() {
        placeholderView?.removeFromSuperview()
        if !placeholderTitle.isEmpty {
            placeholderView = FetchedPlaceholderView(frame: tableView.frame, title: placeholderTitle)
            view.insertSubview(placeholderView!, aboveSubview: tableView)
        }
    }
    
    //MARK: Data
    
    func fetchObjects() {
        let hud = PendingHUDView.show(on: navigationController?.view ?? view)
        
        AppDelegate.instance.dataQueue.async { [weak self] in
            let fmd = self?.createFetchedModelAdapter()
            DispatchQueue.main.async {
                self?.bag = DisposeBag()
                self?.configureSubrcibers(for: fmd)
                self?.fetchedModelAdapter = fmd
                self?.configureTable()
                self?.tableView.reloadData()
                self?.checkNeedsPlaceholder()
                self?.contentChanged()
                hud.hide()
            }
        }
    }
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> Any? {
        return dataSource?.object(at: indexPath)
    }
    
    func configureSubrcibers(for adapter: FetchedModelAdapter?) {
        guard let fetchedModelAdapter = adapter else { return }
        fetchedModelAdapter.delegate = dataSource
        dataSource.didSetModels(fetchedModelAdapter.allObjects())

        fetchedModelAdapter.rx.didChangeContent
            .subscribe(onNext: { [weak self] in
                self?.contentChanged()
            }).disposed(by: bag)
    }
    
    func contentChanged() {
        Logger.debug("contentChanged")
        checkNeedsPlaceholder()
    }
    
    func createFetchedModelAdapter() -> FetchedModelAdapter? {
        Logger.debug("createFetchedModelAdapter")
        return nil
    }
    
    func delete(object: Any!, at indexPath: IndexPath) {
        Logger.debug("deleteObject:atIndexPath:\(indexPath)")
    }
    
    func tappedObject(_ tapped: Any, indexPath: IndexPath) {
        Logger.debug("tappedObject:atIndexPath:\(indexPath)")
    }
}

extension FetchedTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tapped = self.objectAtIndexPath(indexPath)
        tappedObject(tapped!, indexPath: indexPath)
    }
}

extension FetchedTableViewController {
    enum TableType {
        case plain, sections
    }
}
