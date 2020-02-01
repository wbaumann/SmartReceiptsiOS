//
//  FetchedTableViewDataSource.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 24.01.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import UIKit

extension FetchedTableViewController {
    typealias CanMoveClosure = (IndexPath) -> Bool
    typealias MoveClosure = (IndexPath, IndexPath) -> Void
    typealias DeleteClosure = (IndexPath) -> Void
    typealias ConfigureCellClosure = (_ cell: UITableViewCell, _ item: Any) -> Void
}

class FetchedTableViewDataSource: NSObject {
    let cellId: String
    
    private weak var tableView: UITableView?
    fileprivate(set) var items: [Any] = []
    
    fileprivate let configureCell: FetchedTableViewController.ConfigureCellClosure?
    var canMoveRow: FetchedTableViewController.CanMoveClosure?
    var moveRow: FetchedTableViewController.MoveClosure?
    var deleteRow: FetchedTableViewController.DeleteClosure?
    
    fileprivate var isUpdating = false
    
    init(tableView: UITableView, cellId: String, configureCell: FetchedTableViewController.ConfigureCellClosure?) {
        self.tableView = tableView
        self.cellId = cellId
        self.configureCell = configureCell
    }
    
    func map(index: Int, deletion: Bool = false) -> IndexPath {
        return IndexPath(row: index, section: 0)
    }
    
    func object(at indexPath: IndexPath) -> Any {
        return items[indexPath.row]
    }
    
    func needDelete(section: Int) -> Bool {
        return false
    }
    
    func needInsert(section: Int) -> Bool {
        return false
    }
    
    func isChangedSection(item: Any!) -> Bool {
        return false
    }
}

extension FetchedTableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        configureCell?(cell, items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return canMoveRow?(indexPath) ?? false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveRow?(sourceIndexPath, destinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteRow?(indexPath)
        default: break
        }
    }
    
}

extension FetchedTableViewDataSource: FetchedModelAdapterDelegate {
    
    func willChangeContent() {
        guard !isUpdating else { return }
        tableView?.beginUpdates()
        isUpdating = true
    }
    
    func didSetModels(_ models: [Any]!) {
        items = models
    }
    
    func didInsert(_ object: Any!, at index: UInt) {
        let indexPath = map(index: Int(index))
        if needInsert(section: indexPath.section) {
            tableView?.insertSections([indexPath.section], animationStyle: .automatic)
        } else {
            tableView?.insertRows(at: [indexPath], with: .left)
        }
    }
    
    func didDelete(_ object: Any!, at index: UInt) {
        let indexPath = map(index: Int(index), deletion: true)
        if needDelete(section: indexPath.section) {
            tableView?.deleteSections([indexPath.section], animationStyle: .automatic)
        } else {
            tableView?.deleteRows(at: [indexPath], with: .right)
        }
    }
    
    func didUpdate(_ object: Any!, at index: UInt) {
        if isChangedSection(item: object) {
            didDelete(object, at: index)
            didInsert(object, at: index)
        } else {
            tableView?.reloadRows(at: [map(index: Int(index))], with: .automatic)
        }
    }
    
    func didMove(_ object: Any!, from fromIndex: UInt, to toIndex: UInt) {
        didDelete(object, at: fromIndex)
        didInsert(object, at: toIndex)
    }
    
    func didChangeContent() {
        guard isUpdating else { return }
        tableView?.endUpdates()
        isUpdating = false
    }
    
    func reloadData() {
        isUpdating ? tableView?.endUpdates() : tableView?.reloadData()
    }
}

class DateSectionedTableViewDataSource: FetchedTableViewDataSource {
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
    
    override func didSetModels(_ models: [Any]!) {
        guard let newItems = models as? [DateSectionItem] else { return }
        previousItems = items
        items = newItems
        previousSortedKeys = sortedKeys
        previousSectionedItems = sectionedItems
        sectionedItems = [:]
        sortedKeys = newItems.map { $0.sectionDate }.uniques.sorted { $0 > $1 }
        for item in newItems {
            if sectionedItems.keys.contains(item.sectionDate) == true {
                sectionedItems[item.sectionDate]?.append(item)
            } else {
                sectionedItems[item.sectionDate] = [item]
            }
        }
    }
    
    override func needDelete(section: Int) -> Bool {
        return previousSectionedItems[previousSortedKeys[section]]?.count == 1
    }
    
    override func needInsert(section: Int) -> Bool {
        return previousSectionedItems[sortedKeys[section]] == nil
    }
    
    override func isChangedSection(item: Any!) -> Bool {
        guard let dsItem = item as? DateSectionItem else { return false }
        let previousItem = previousSectionedItems.flatMap { $0.value }.first(where: { $0.id == dsItem.id })
        return previousItem?.sectionDate != dsItem.sectionDate
    }
    
    override func map(index: Int, deletion: Bool = false) -> IndexPath {
        let rawItems = deletion ? previousItems : items
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section < sortedKeys.count else { return nil }
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
