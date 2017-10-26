//
//  OCRConfigurationView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 25/10/2017.
//Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit

//MARK: - Public Interface Protocol
protocol OCRConfigurationViewInterface {
}

//MARK: OCRConfigurationView Class
final class OCRConfigurationView: UserInterface {
}

//MARK: - Public interface
extension OCRConfigurationView: OCRConfigurationViewInterface {
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension OCRConfigurationView {
    var presenter: OCRConfigurationPresenter {
        return _presenter as! OCRConfigurationPresenter
    }
    var displayData: OCRConfigurationDisplayData {
        return _displayData as! OCRConfigurationDisplayData
    }
}
