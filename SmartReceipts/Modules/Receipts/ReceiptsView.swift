//
//  ReceiptsView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 18/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit

//MARK: - Public Interface Protocol
protocol ReceiptsViewInterface {
}

//MARK: ReceiptsView Class
final class ReceiptsView: UserInterface {
}

//MARK: - Public interface
extension ReceiptsView: ReceiptsViewInterface {
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension ReceiptsView {
    var presenter: ReceiptsPresenter {
        return _presenter as! ReceiptsPresenter
    }
    var displayData: ReceiptsDisplayData {
        return _displayData as! ReceiptsDisplayData
    }
}
