//
//  EditReceiptView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit

//MARK: - Public Interface Protocol
protocol EditReceiptViewInterface {
}

//MARK: EditReceiptView Class
final class EditReceiptView: UserInterface {
}

//MARK: - Public interface
extension EditReceiptView: EditReceiptViewInterface {
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditReceiptView {
    var presenter: EditReceiptPresenter {
        return _presenter as! EditReceiptPresenter
    }
    var displayData: EditReceiptDisplayData {
        return _displayData as! EditReceiptDisplayData
    }
}
