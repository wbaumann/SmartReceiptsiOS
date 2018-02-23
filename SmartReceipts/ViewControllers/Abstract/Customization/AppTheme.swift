//
//  AppTheme.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class AppTheme: NSObject {
    
    static let appTitle = "Smart Receipts"
    
    static let buttonCornerRadius: CGFloat = 5
    
    // Colors
    static let primaryColor               = #colorLiteral(red: 0.4784313725, green: 0.1176470588, blue: 0.631372549, alpha: 1)
    static let primaryDarkColor           = #colorLiteral(red: 0.4117647059, green: 0.1019607843, blue: 0.6, alpha: 1)
    static let accentColor                = #colorLiteral(red: 0.4078431373, green: 0.937254902, blue: 0.6784313725, alpha: 1)
    static let cellColor                  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let reportPDFStyleColor        = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    static let toolbarTintColor           = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let buttonStyle1NormalColor    = #colorLiteral(red: 0.537254902, green: 0.137254902, blue: 0.7137254902, alpha: 1)
    static let buttonStyle1PressedColor   = #colorLiteral(red: 0.3334693832, green: 0.08451540429, blue: 0.4416083583, alpha: 1)
    
    // Fonts
    static let boldFont = UIFont.boldSystemFont(ofSize: 17)
    
    class func customizeOnAppLoad() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = primaryColor
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UIToolbar.appearance().tintColor = primaryDarkColor
    }
    
    /* Customizes every view controller on load */
    class func customizeOnViewDidLoad(_ viewController: UIViewController) {
        if let _ = viewController.navigationController {
            // configure navigation bar here, to do some more fancy things
        }
        
        // changes color of active elements like buttons and segments, unfortunately alertview cannot be costumized
        UIApplication.shared.keyWindow?.tintColor = primaryColor
        
        // chanes status bar color, however iOS built-in controllers (for example mail composer) may override it
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
}

enum PDFFontStyle {
    case title
    case `default`
    case defaultBold
    case tableHeader
    case small
    case footer
    
    var fontSize: CGFloat {
        let titleSize: CGFloat = 13
        let defaultSize: CGFloat = 11
        let smallSize: CGFloat = 9
        
        switch self {
        case .title:
            return titleSize
        case .default, .defaultBold, .tableHeader:
            return defaultSize
        case .small, .footer:
            return smallSize
        }
    }
    
    var font: UIFont {
        switch self {
        case .title:
            return UIFont.boldSystemFont(ofSize: fontSize)
        case .default:
            return UIFont.systemFont(ofSize: fontSize)
        case .defaultBold, .tableHeader:
            return UIFont.boldSystemFont(ofSize: fontSize)
        case .small:
            return UIFont.systemFont(ofSize: fontSize)
        case .footer:
            return UIFont.italicSystemFont(ofSize: fontSize)
        }
    }
}
