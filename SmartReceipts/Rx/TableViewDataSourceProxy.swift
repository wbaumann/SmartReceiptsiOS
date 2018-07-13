//
//  TableViewDataSourceProxy.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/08/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import RxCocoa

class TableViewDataSourceProxy: NSObject, UITableViewDataSource {
    typealias ConfigureCellClosure = (_ row: Int, _ cell: UITableViewCell, _ item: Any) -> Void
    
    let items = BehaviorRelay<[Any]>(value: [Any]())
    let bag = DisposeBag()
    
    let willChangeContent = PublishSubject<Void>()
    let didChangeContent = PublishSubject<Void>()
    let didInsert = PublishSubject<FetchedObjectAction>()
    let didDelete = PublishSubject<FetchedObjectAction>()
    let didUpdate = PublishSubject<FetchedObjectAction>()
    let didMove = PublishSubject<MoveFetchedObjectAction>()
    let reloadData = PublishSubject<Void>()
    
    var canMoveRow: ((IndexPath) -> Bool)?
    var moveRow: ((IndexPath, IndexPath) -> Void)?
    
    private weak var tableView: UITableView!
    private var cellID: String!
    private var configureCell: ConfigureCellClosure?
    
    private var isUpdating = false
    
    init(_ tableView: UITableView, cellID: String, configureCell: ConfigureCellClosure?) {
        super.init()
        self.cellID = cellID
        self.configureCell = configureCell
        self.tableView = tableView
        
        willChangeContent
            .filter({ [unowned self] in !self.isUpdating })
            .subscribe(onNext: { [unowned self] in
                self.tableView.beginUpdates()
                self.isUpdating = true
            }).disposed(by: bag)
        
        didChangeContent
            .filter({ [unowned self] in self.isUpdating })
            .subscribe(onNext: { [unowned self] in
                self.tableView.endUpdates()
                self.isUpdating = false
            }).disposed(by: bag)
        
        didInsert.subscribe(onNext: { [unowned self] action in
            self.tableView.insertRows(at: [IndexPath(row: action.index, section: 0)], with: .top)
        }).disposed(by: bag)
        
        didDelete.subscribe(onNext: { [unowned self] action in
            self.tableView.deleteRows(at: [IndexPath(row: action.index, section: 0)], with: .left)
        }).disposed(by: bag)
        
        didUpdate.subscribe(onNext: { [unowned self] action in
            self.tableView.reloadRows(at: [IndexPath(row: action.index, section: 0)], with: .fade)
        }).disposed(by: bag)
        
        didMove.subscribe(onNext: { [unowned self] action in
            self.tableView.deleteRows(at: [IndexPath(row: action.from, section: 0)], with: .automatic)
            self.tableView.insertRows(at: [IndexPath(row: action.to, section: 0)], with: .automatic)
        }).disposed(by: bag)
        
        reloadData.subscribe(onNext: { [unowned self] in
            self.isUpdating ? self.tableView.endUpdates() : self.tableView.reloadData()
        }).disposed(by: bag)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        configureCell?(indexPath.row, cell, items.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.value.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return canMoveRow?(indexPath) ?? false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveRow?(sourceIndexPath, destinationIndexPath)
    }
}
