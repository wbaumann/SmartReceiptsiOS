//
//  ReceiptActionsView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit

//MARK: - Public Interface Protocol
protocol ReceiptActionsViewInterface {
}

//MARK: ReceiptActionsView Class
final class ReceiptActionsView: UserInterface {
}

//MARK: - Public interface
extension ReceiptActionsView: ReceiptActionsViewInterface {
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptActionsView {
    var presenter: ReceiptActionsPresenter {
        return _presenter as! ReceiptActionsPresenter
    }
    var displayData: ReceiptActionsDisplayData {
        return _displayData as! ReceiptActionsDisplayData
    }
}
