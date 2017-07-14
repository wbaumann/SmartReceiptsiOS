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

class ColumnsDisplayData: DisplayData {
    var columns = Variable([Column]())
    let columsNames = ReceiptColumn.availableColumnsNames() as! [String]
}
