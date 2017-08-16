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
    
    let items = Variable<[Any]>([Any]())
    let bag = DisposeBag()
    
    let willChangeContent = PublishSubject<Void>()
    let didChangeContent = PublishSubject<Void>()
    let didInsert = PublishSubject<FetchedObjectAction>()
    let didDelete = PublishSubject<FetchedObjectAction>()
    let didUpdate = PublishSubject<FetchedObjectAction>()
    let didMove = PublishSubject<MoveFetchedObjectAction>()
    let reloadData = PublishSubject<Void>()
    
    private weak var tableView: UITableView!
    private var cellID: String!
    private var configureCell: ConfigureCellClosure?
    
    init(_ tableView: UITableView, cellID: String, configureCell: ConfigureCellClosure?) {
        super.init()
        self.cellID = cellID
        self.configureCell = configureCell
        self.tableView = tableView
        
        willChangeContent.subscribe(onNext: { [unowned self] in
            self.tableView.beginUpdates()
        }).disposed(by: bag)
        
        didChangeContent.subscribe(onNext: { [unowned self] in
            self.tableView.endUpdates()
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
            self.tableView.reloadData()
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
}
