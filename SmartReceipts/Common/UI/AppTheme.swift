//
//  AppTheme.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

class AppTheme: NSObject {
    
    static let appTitle = LocalizedString("sr_app_name")
    static let appTitlePlus = LocalizedString("sr_app_name_plus")

    static let buttonCornerRadius: CGFloat = 5
    
    // Colors
    static let primaryColor               = UIColor.srViolet
    static let primaryDarkColor           = UIColor.srViolet2
    static let accentColor                = #colorLiteral(red: 0.4078431373, green: 0.937254902, blue: 0.6784313725, alpha: 1)
    static let cellColor                  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let errorColor                 = #colorLiteral(red: 0.8738889729, green: 0.1913453077, blue: 0.2091978607, alpha: 1)
    static let reportPDFStyleColor        = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    static let toolbarTintColor           = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let buttonStyle1NormalColor    = #colorLiteral(red: 0.537254902, green: 0.137254902, blue: 0.7137254902, alpha: 1)
    static let buttonStyle1PressedColor   = #colorLiteral(red: 0.3334693832, green: 0.08451540429, blue: 0.4416083583, alpha: 1)
    
    // Fonts
    static let boldFont = UIFont.boldSystemFont(ofSize: 17)
    
    class func customizeOnAppLoad() {
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = primaryColor
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white]
        UIToolbar.appearance().tintColor = primaryDarkColor
    }
    
    /* Customizes every view controller on load */
    class func customizeOnViewDidLoad(_ viewController: UIViewController) {
        if let _ = viewController.navigationController {
            // configure navigation bar here, to do some more fancy things
        }
        
        // changes color of active elements like buttons and segments, unfortunately alertview cannot be costumized
        UIApplication.shared.keyWindow?.tintColor = primaryColor
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
            return .boldSystemFont(ofSize: fontSize)
        case .default:
            return .systemFont(ofSize: fontSize)
        case .defaultBold, .tableHeader:
            return .boldSystemFont(ofSize: fontSize)
        case .small:
            return .systemFont(ofSize: fontSize)
        case .footer:
            return .italicSystemFont(ofSize: fontSize)
        }
    }
}
