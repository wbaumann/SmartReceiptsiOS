//
//  BackupView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14/02/2018.
//Copyright © 2018 Will Baumann. All rights reserved.
//

import UIKit
import Viperit

//MARK: - Public Interface Protocol
protocol BackupViewInterface {
}

//MARK: BackupView Class
final class BackupView: UserInterface {
}

//MARK: - Public interface
extension BackupView: BackupViewInterface {
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension BackupView {
    var presenter: BackupPresenter {
        return _presenter as! BackupPresenter
    }
    var displayData: BackupDisplayData {
        return _displayData as! BackupDisplayData
    }
}
