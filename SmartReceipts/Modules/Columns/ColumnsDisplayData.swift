//
//  ColumnsDisplayData.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 12/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit
import RxSwift
import RxCocoa

class ColumnsDisplayData: DisplayData {
    var columns = BehaviorRelay(value: [Column]())
    let columsNames = ReceiptColumn.availableColumnsNames() as! [String]
}
