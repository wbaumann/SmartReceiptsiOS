//
//  EditDistanceView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit

//MARK: - Public Interface Protocol
protocol EditDistanceViewInterface {
}

//MARK: EditDistance View
final class EditDistanceView: UserInterface {
}

//MARK: - Public interface
extension EditDistanceView: EditDistanceViewInterface {
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension EditDistanceView {
    var presenter: EditDistancePresenter {
        return _presenter as! EditDistancePresenter
    }
    var displayData: EditDistanceDisplayData {
        return _displayData as! EditDistanceDisplayData
    }
}
