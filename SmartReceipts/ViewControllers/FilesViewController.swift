//
//  FilesViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 27/01/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

@available(iOS 11.0, *)
class FilesViewController: UIDocumentBrowserViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIBarButtonItem.appearance().tintColor = AppTheme.primaryDarkColor
        
        allowsDocumentCreation = false
        additionalTrailingNavigationBarButtonItems = [
            UIBarButtonItem(title: LocalizedString("receipt_import_action_cancel"),
                            style: .plain, target: self, action: #selector(FilesViewController.close))
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIBarButtonItem.appearance().tintColor = .white
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @objc fileprivate func close() {
        dismiss(animated: true, completion: nil)
    }
}
