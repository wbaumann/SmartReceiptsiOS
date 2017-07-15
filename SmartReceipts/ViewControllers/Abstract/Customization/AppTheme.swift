//
//  AppTheme.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class AppTheme: NSObject {
    
    // Colors
    static let themeColor           = #colorLiteral(red: 0.5803921569, green: 0, blue: 0.8274509804, alpha: 1)
    static let reportPDFStyleColor  = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    static let toolbarTintColor     = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    // Fonts
    static let boldFont = UIFont.boldSystemFont(ofSize: 17)
    
    class func customizeOnAppLoad() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = themeColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UIToolbar.appearance().tintColor = themeColor
    }
    
    /* Customizes every view controller on load */
    class func customizeOnViewDidLoad(_ viewController: UIViewController) {
        if let _ = viewController.navigationController {
            // configure navigation bar here, to do some more fancy things
        }
        
        // changes color of active elements like buttons and segments, unfortunately alertview cannot be costumized
        UIApplication.shared.keyWindow?.tintColor = themeColor
        
        // chanes status bar color, however iOS built-in controllers (for example mail composer) may override it
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
