//
//  ReceiptMoveCopyView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 22/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit

//MARK: - Public Interface Protocol
protocol ReceiptMoveCopyViewInterface {
    func setup(fetchedModelAdapter: FetchedModelAdapter)
}

//MARK: ReceiptMoveCopyView Class
final class ReceiptMoveCopyView: FetchedTableViewController {

    var isCopyOrMove: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppTheme.customizeOnViewDidLoad(self)
        //setPresentationCellNib(TitleOnlyCell.viewNib())
        
        if presenter.isCopy {
            navigationItem.title = LocalizedString("copy")
        } else {
            navigationItem.title = LocalizedString("move")
        }
    }
    
    override func configureCell(cell: UITableViewCell, item: Any) {
        let trip = item as! WBTrip
        cell.textLabel?.text = trip.name
    }
    
    override func createFetchedModelAdapter() -> FetchedModelAdapter? {
        return displayData.fetchedModelAdapter
    }
    
    override func tappedObject(_ tapped: Any, indexPath: IndexPath) {
        presenter.tripTapSubject.onNext(tapped as! WBTrip)
    }
}

//MARK: - Public interface
extension ReceiptMoveCopyView: ReceiptMoveCopyViewInterface {
    func setup(fetchedModelAdapter: FetchedModelAdapter) {
        displayData.fetchedModelAdapter = fetchedModelAdapter
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptMoveCopyView {
    var presenter: ReceiptMoveCopyPresenter {
        return _presenter as! ReceiptMoveCopyPresenter
    }
    var displayData: ReceiptMoveCopyDisplayData {
        return _displayData as! ReceiptMoveCopyDisplayData
    }
}
