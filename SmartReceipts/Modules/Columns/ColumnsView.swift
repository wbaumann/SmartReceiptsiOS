//
//  ColumnsView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit
import RxCocoa
import RxSwift
import RxDataSources

//MARK: - Public Interface Protocol
protocol ColumnsViewInterface {
    var columnsVar: BehaviorRelay<[Column]> { get }
    func setNavTitle(_ title: String)
}

//MARK: ColumnsView Class
final class ColumnsView: UserInterface, WBDynamicPickerDelegate {
    typealias ColumnSection = AnimatableSectionModel<String, Column>
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addItem: UIBarButtonItem!
    
    private var dynamicPicker: WBDynamicPicker!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = makeTableDataSource()
        configureRx()
        
        displayData.columns.asObservable().flatMap({ receipts -> Observable<[ColumnSection]> in
            return Observable<[ColumnSection]>.just([ColumnSection(model: "", items: receipts)])
        }).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        addItem.rx.tap.subscribe(onNext: { [unowned self] in
            self.dynamicPicker.show(from: self.addItem)
        }).disposed(by: bag)
        
        
        dynamicPicker = WBDynamicPicker(type: WBDynamicPickerTypePicker, with: self)
        dynamicPicker.setTitle(LocalizedString("dialog_custom_csv_spinner"))
        dynamicPicker.delegate = self
        
        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.toolbar.barTintColor = AppTheme.toolbarTintColor
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [space, self.editButtonItem]
        
        AppTheme.customizeOnViewDidLoad(self)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    func makeTableDataSource() -> RxTableViewSectionedAnimatedDataSource<ColumnSection> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<ColumnSection>(
            configureCell: { (dataSource, table, idxPath, item) in
                let cell = table.dequeueReusableCell(withIdentifier: "Cell", for: idxPath)
                let number = idxPath.row + 1
                cell.textLabel?.text = String(format: LocalizedString("column_item"), "\(number)")
                cell.detailTextLabel?.text = item.name
                return cell
        })
        
        dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .top,
                                                                   reloadAnimation: .fade,
                                                                   deleteAnimation: .left)
        
        dataSource.canEditRowAtIndexPath = { _,_  in return true }
        dataSource.canMoveRowAtIndexPath = { _,_  in return true }
        
        return dataSource
    }
        
    func configureRx() {
        tableView.rx.itemMoved.subscribe(onNext: { [unowned self] (from: IndexPath, to: IndexPath) in
            var newColumns = self.displayData.columns.value
            
            let columnOne = newColumns[from.row]
            let columnTwo = newColumns[to.row]
            
            self.presenter.reorderSubject.onNext((columnOne, columnTwo))
            self.presenter.updateData()
        }).disposed(by: bag)
        
        tableView.rx.itemDeleted.subscribe(onNext: { [unowned self] indexPath in
            let column = self.displayData.columns.value[indexPath.row]
            self.presenter.removeSubject.onNext(column)
            self.presenter.updateData()
        }).disposed(by: bag)
    }
    
    func dynamicPickerNumber(ofRows picker: WBDynamicPicker!) -> Int {
        return displayData.columsNames.count
    }
    
    func dynamicPicker(_ picker: WBDynamicPicker!, titleForRow row: Int) -> String! {
        return displayData.columsNames[row]
    }
    
    func dynamicPicker(_ picker: WBDynamicPicker!, doneWith subject: Any!) {
        let columnName = displayData.columsNames[dynamicPicker.selectedRow()]
        let column = ReceiptColumn(index: presenter.nextObjectID(), name: columnName)!
        column.uniqueIdentity = "\(Date())"
        presenter.addSubject.onNext(column)
        self.presenter.updateData()
    }
}

//MARK: - Public interface
extension ColumnsView: ColumnsViewInterface {
    
    var columnsVar: BehaviorRelay<[Column]> { get { return displayData.columns } }
    
    func setNavTitle(_ title: String) {
        navigationItem.title = title
    }
}

//MARK: Column: IdentifiableType
extension Column: IdentifiableType {
    public var identity: String {
        return uniqueIdentity
    }
}


// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ColumnsView {
    var presenter: ColumnsPresenter {
        return _presenter as! ColumnsPresenter
    }
    var displayData: ColumnsDisplayData {
        return _displayData as! ColumnsDisplayData
    }
}
