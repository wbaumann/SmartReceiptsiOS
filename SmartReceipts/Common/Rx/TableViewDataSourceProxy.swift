//
//  TableViewDataSourceProxy.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/08/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

protocol TableViewDataSourceProvider {
    var dataSource: UITableViewDataSource { get }
    func object(at indexPath: IndexPath) -> Any
}

class TableViewDataSourceProxy: TableViewDataSourceProvider {
    typealias CanMoveClosure = (IndexPath) -> Bool
    typealias MoveClosure = (IndexPath, IndexPath) -> Void
    typealias ConfigureCellClosure = (_ cell: UITableViewCell, _ item: Any) -> Void
    
    let items = BehaviorRelay<[Any]>(value: [Any]())
    let willChangeContent = PublishSubject<Void>()
    let didChangeContent = PublishSubject<Void>()
    let didInsert = PublishSubject<FetchedObjectAction>()
    let didDelete = PublishSubject<FetchedObjectAction>()
    let didUpdate = PublishSubject<FetchedObjectAction>()
    let didMove = PublishSubject<MoveFetchedObjectAction>()
    let reloadData = PublishSubject<Void>()
    
    var canMoveRow: CanMoveClosure? {
        didSet { _dataSource.canMoveRow = canMoveRow }
    }
    
    var moveRow: MoveClosure? {
        didSet { _dataSource.moveRow = moveRow }
    }
    
    let bag = DisposeBag()
    private weak var tableView: UITableView!
    
    private let _dataSource: TableViewDataSource
    var dataSource: UITableViewDataSource { return _dataSource }
    
    private var isUpdating = false
    
    init(_ tableView: UITableView, cellID: String, type: TableType, configureCell: ConfigureCellClosure?) {
        switch type {
        case .plain:
            self._dataSource = TableViewDataSource(cellId: cellID, configureCell: configureCell, source: items)
        case .sections:
            self._dataSource = DateSectionedTableViewDataSource(cellId: cellID, configureCell: configureCell, source: items)
        }
                
        self.tableView = tableView
        self.tableView.dataSource = _dataSource
        
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
            let indexPath = self._dataSource.map(index: action.index)
            if self._dataSource.needInsert(section: indexPath.section) {
                self.tableView.insertSections([indexPath.section], animationStyle: .automatic)
            } else {
                self.tableView.insertRows(at: [indexPath], with: .left)
            }
        }).disposed(by: bag)
        
        didDelete.subscribe(onNext: { [unowned self] action in
            let indexPath = self._dataSource.map(index: action.index, deletion: true)
            if self._dataSource.needDelete(section: indexPath.section) {
                self.tableView.deleteSections([indexPath.section], animationStyle: .automatic)
            } else {
                self.tableView.deleteRows(at: [indexPath], with: .right)
            }
        }).disposed(by: bag)
        
        didUpdate.subscribe(onNext: { [unowned self] action in
            if self._dataSource.isChangedSection(item: action.object) {
                self.didDelete.onNext((action.object, action.index))
                self.didInsert.onNext((action.object, action.index))
            } else {
                self.tableView.reloadRows(at: [self._dataSource.map(index: action.index)], with: .fade)
            }
        }).disposed(by: bag)
        
        didMove.subscribe(onNext: { [unowned self] action in
            self.didDelete.onNext((action.object, action.from))
            self.didInsert.onNext((action.object, action.to))
        }).disposed(by: bag)
        
        reloadData.subscribe(onNext: { [unowned self] in
            self.isUpdating ? self.tableView.endUpdates() : self.tableView.reloadData()
        }).disposed(by: bag)
    }
    
    func object(at indexPath: IndexPath) -> Any {
        return _dataSource.object(at: indexPath)
    }
    
    enum TableType {
        case plain, sections
    }
}

// MARK: - Implementations

private class TableViewDataSource: NSObject, UITableViewDataSource {
    let cellId: String
    let configureCell: TableViewDataSourceProxy.ConfigureCellClosure?
    let items: BehaviorRelay<[Any]>
    var canMoveRow: TableViewDataSourceProxy.CanMoveClosure?
    var moveRow: TableViewDataSourceProxy.MoveClosure?
    
    init(cellId: String, configureCell: TableViewDataSourceProxy.ConfigureCellClosure?, source: BehaviorRelay<[Any]>) {
        self.cellId = cellId
        self.configureCell = configureCell
        self.items = source
    }
    
    func map(index: Int, deletion: Bool = false) -> IndexPath {
        return IndexPath(row: index, section: 0)
    }
    
    func object(at indexPath: IndexPath) -> Any {
        return items.value[indexPath.row]
    }
    
    func needDelete(section: Int) -> Bool {
        return false
    }
    
    func needInsert(section: Int) -> Bool {
        return false
    }
    
    func isChangedSection(item: Any) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        configureCell?(cell, items.value[indexPath.row])
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

private class DateSectionedTableViewDataSource: TableViewDataSource {
    private let bag = DisposeBag()
    
    private var previousItems = [Any]()
    private var previousSectionedItems = [Date : [DateSectionItem]]()
    private var previousSortedKeys = [Date]()
    
    private var sectionedItems = [Date : [DateSectionItem]]()
    private var sortedKeys = [Date]()
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.configure()
        return formatter
    }()
    
    override init(cellId: String, configureCell: TableViewDataSourceProxy.ConfigureCellClosure?, source: BehaviorRelay<[Any]>) {
        super.init(cellId: cellId, configureCell: configureCell, source: source)
        source.map { items in items as? [DateSectionItem] }
            .filterNil()
            .scan([], accumulator: { [unowned self] seed, new -> [DateSectionItem] in
                self.previousItems = seed
                return new
            })
            .do(onNext: { [weak self] items in
                self?.previousSortedKeys = self?.sortedKeys ?? []
                self?.previousSectionedItems = self?.sectionedItems ?? [:]
                self?.sectionedItems = [:]
                self?.sortedKeys = items.map { $0.sectionDate }.uniques.sorted { $0 > $1 }
            }).flatMap({ Observable.from($0) })
            .subscribe(onNext: { [weak self] item in
                if self?.sectionedItems.keys.contains(item.sectionDate) == true {
                    self?.sectionedItems[item.sectionDate]?.append(item)
                } else {
                    self?.sectionedItems[item.sectionDate] = [item]
                }
            }).disposed(by: bag)
    }
    
    override func needDelete(section: Int) -> Bool {
        return previousSectionedItems[previousSortedKeys[section]]?.count == 1
    }
    
    override func needInsert(section: Int) -> Bool {
        return previousSectionedItems[sortedKeys[section]] == nil
    }
    
    override func isChangedSection(item: Any) -> Bool {
        guard let item = item as? DateSectionItem else { return false }
        let previousItem = previousSectionedItems.flatMap { $0.value }.first(where: { $0.id == item.id })
        return previousItem?.sectionDate != item.sectionDate
    }
    
    override func map(index: Int, deletion: Bool = false) -> IndexPath {
        let rawItems = deletion ? previousItems : items.value
        let item = rawItems[index] as! DateSectionItem
        let keys = deletion ? previousSortedKeys : sortedKeys
        let section = keys.index(of: item.sectionDate) ?? 0
        let currentItems = deletion ? previousSectionedItems : sectionedItems
        guard let items = currentItems[item.sectionDate] else { return .init(row: 0, section: section) }
        for (idx, element) in items.enumerated() {
            if element.id == item.id {
                return .init(row: idx, section: section)
            }
        }
        return .init(row: 0, section: section)
    }
    
    override func object(at indexPath: IndexPath) -> Any {
        return sectionedItems[sortedKeys[indexPath.section]]?[indexPath.row] as Any
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        configureCell?(cell, object(at: indexPath))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionedItems[sortedKeys[section]]?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedKeys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateFormatter.string(from: sortedKeys[section])
    }
}

protocol DateSectionItem {
    var sectionDate: Date { get }
    var id: String { get }
}

extension WBReceipt: DateSectionItem {
    var sectionDate: Date { return (date as NSDate).atBeginningOfDay() }
    var id: String { return String(self.objectId) }
}

extension Distance: DateSectionItem {
    var sectionDate: Date { return (date as NSDate).atBeginningOfDay() }
    var id: String { return String(self.objectId) }
}

