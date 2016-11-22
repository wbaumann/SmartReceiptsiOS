//
//  SettingsViewController.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 09/06/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension SettingsViewController {
    func shareBackupFile(_ path: String, fromRect: CGRect) {
        var showRect = fromRect
        showRect.origin.y += view.frame.origin.y - fromRect.height
        
        let controller = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
        controller.presentOptionsMenu(from: showRect, in: view, animated: true)
        documentInteractionController = controller
    }
}
