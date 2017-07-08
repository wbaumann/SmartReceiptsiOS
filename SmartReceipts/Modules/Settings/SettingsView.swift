//
//  SettingsView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Viperit

//MARK: - Public Interface Protocol
protocol SettingsViewInterface {
    var doneButton: UIBarButtonItem { get }
}

//MARK: SettingsView Class
final class SettingsView: UserInterface {
    
    @IBOutlet fileprivate weak var doneButtonItem: UIBarButtonItem!
    
    var formView: SettingsFormView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalizedString("settings.controller.title")
        
        formView = SettingsFormView()
        
        addChildViewController(formView)
        view.addSubview(formView.view)
    }
}

//MARK: - Public interface
extension SettingsView: SettingsViewInterface {
    var doneButton: UIBarButtonItem { get{ return doneButtonItem } }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension SettingsView {
    var presenter: SettingsPresenter {
        return _presenter as! SettingsPresenter
    }
    var displayData: SettingsDisplayData {
        return _displayData as! SettingsDisplayData
    }
}
