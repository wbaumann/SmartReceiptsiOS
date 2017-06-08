//
//  GenerateReportRouter.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

final class GenerateReportRouter: Router {
    func close() {
        _view.dismiss(animated: true, completion: nil)
    }
    
    func openAlert(title: String, message: String) {
        UIAlertView(title: title, message: message, delegate: nil,
                    cancelButtonTitle: LocalizedString("generic.button.title.ok")).show()
    }
    
    func openSheet(title: String?, message: String?, actions: [UIAlertAction]) {
        let sheet = UIAlertController(title: nil, message: LocalizedString("generate.report.share.method.sheet.title"), preferredStyle: .alert)
        for action in actions {
            sheet.addAction(action)
        }
        _view.present(sheet, animated: true, completion: nil)
    }
    
    func openSettings() {
        AnalyticsManager.sharedManager.record(event: Event.informationalConfigureReport())
        
        let storyboard = MainStoryboard()
        let settingsOverflow = storyboard.instantiateViewController(withIdentifier: "SettingsOverflow") as! UINavigationController
        let settingsVC = settingsOverflow.viewControllers.first as? SettingsViewController
        if (settingsVC != nil) {
            Logger.debug("goToSettings: wasPresentedFromGeneratorVC = YES")
            settingsVC!.wasPresentedFromGeneratorVC = true
        }
        
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            settingsOverflow.modalPresentationStyle = .overCurrentContext;
        }
        settingsOverflow.modalTransitionStyle = .coverVertical
        _view.present(settingsOverflow, animated: true, completion: nil)
    }
    
    func open(vc: UIViewController, animated: Bool = true, isPopover: Bool = false, completion: (() -> Void)? = nil) {
        if isPopover {
            // For iPad
            if let popover = vc.popoverPresentationController {
                popover.permittedArrowDirections = .up
                popover.sourceView = _view.view
                popover.sourceRect = _view.navigationController?.navigationBar.frame ?? _view.view.frame
            }
        }
        _view.present(vc, animated: animated, completion: completion)
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension GenerateReportRouter {
    var presenter: GenerateReportPresenter {
        return _presenter as! GenerateReportPresenter
    }
}
