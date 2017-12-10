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

class FetchedTableViewController: UserInterface {
    
    @IBOutlet var tableView: UITableView!
    
    private let FETCHED_COLLECTION_CELL_ID = "FetchedCollectionTableViewControllerCellIdentifier"
    private var bag = DisposeBag()
    private var fetchedModelAdapter: FetchedModelAdapter?
    private var dataSource: TableViewDataSourceProxy!
    
    private(set) var placeholderTitle = ""
    
    var trip: WBTrip?
    var placeholderView: FetchedPlaceholderView?
    var itemsCount: Int { return fetchedModelAdapter?.allObjects().count ?? 0 }
    var fetchedItems: [Any] { return fetchedModelAdapter?.allObjects() ?? [Any]() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        dataSource = TableViewDataSourceProxy(tableView, cellID: FETCHED_COLLECTION_CELL_ID, configureCell: {
            [unowned self] row, cell, item in
            self.configureCell(row: row, cell: cell, item: item)
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        placeholderView?.frame = view.bounds
        UIView.animate(withDuration: 0.3) {
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
        if fetchedModelAdapter == nil {
            fetchObjects()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    private func configureTable() {
        tableView.dataSource = dataSource
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
                let tapped = self.objectAtIndexPath(indexPath)
                self.tappedObject(tapped!, indexPath: indexPath)
            }).disposed(by: bag)
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [unowned self] indexPath in
                let model = self.objectAtIndexPath(indexPath)
                self.delete(object: model!, at: indexPath)
            }).disposed(by: bag)
    }
    
    func setPresentationCellNib(_ nib: UINib) {
        tableView.register(nib, forCellReuseIdentifier: FETCHED_COLLECTION_CELL_ID)
    }
    
    func configureCell(row: Int, cell: UITableViewCell, item: Any) {
        Logger.debug("LOGGER_DEBUG(configureCell:atIndexPath:\(row)")
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
        return fetchedModelAdapter?.object(at: indexPath.row)
    }
    
    func configureSubrcibers(for adapter: FetchedModelAdapter?) {
        guard let fetchedModelAdapter = adapter else { return }
        
        Observable.just(fetchedModelAdapter.allObjects())
            .bind(to: dataSource.items)
            .disposed(by: bag)

        fetchedModelAdapter.rx.willChangeContent
            .bind(to: dataSource.willChangeContent)
            .disposed(by: bag)
        
        fetchedModelAdapter.rx.didSetModels
            .bind(to: dataSource.items)
            .disposed(by: bag)
        
        fetchedModelAdapter.rx.didChangeContent
            .do(onNext: { [weak self] in self?.contentChanged() })
            .bind(to: dataSource.didChangeContent)
            .disposed(by: bag)
        
        fetchedModelAdapter.rx.didInsert
            .bind(to: dataSource.didInsert)
            .disposed(by: bag)
        
        fetchedModelAdapter.rx.didDelete
            .bind(to: dataSource.didDelete)
            .disposed(by: bag)
        
        fetchedModelAdapter.rx.didUpdate
            .bind(to: dataSource.didUpdate)
            .disposed(by: bag)
        
        fetchedModelAdapter.rx.didMove
            .bind(to: dataSource.didMove)
            .disposed(by: bag)
        
        fetchedModelAdapter.rx.reloadData
            .bind(to: dataSource.reloadData)
            .disposed(by: bag)
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
