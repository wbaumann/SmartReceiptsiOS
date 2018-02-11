//
//  EditReceiptDisplayData.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

class EditReceiptDisplayData: DisplayData {
    var receipt: WBReceipt?
    var trip: WBTrip!
    var scan: Scan?
    var needFirstResponder = true
}
