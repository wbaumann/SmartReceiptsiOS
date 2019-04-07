//
//  EurekaWhitespaceWorkaround.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 13/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

// Solution for https://github.com/xmartlabs/Eureka/issues/424

import Foundation
import Eureka

private let REPLACING_CHAR = "\u{00a0}"
private let DICTATION_ID = "dictation"

final class EurekaWhitespaceWorkaround {
    private var textField: UITextField?
    private var isDictation = false
    
    init() {
        let name = UITextInputMode.currentInputModeDidChangeNotification
        let sel = #selector(keyboardModeChanged)
        NotificationCenter.default.addObserver(self, selector: sel, name: name, object: nil)
    }
    
    static func configureTextCells() {
        let workaround = EurekaWhitespaceWorkaround()
        TextRow.defaultCellSetup = { cell, row in
            // the workaround object is retained here on purpose
            workaround.configureWhiteSpaceWorkaround(forTextCell: cell)
        }
    }
    
    func configureWhiteSpaceWorkaround(forTextCell cell: TextCell) {
        textField = cell.textField
        
        cell.textField.addTarget(self, action: #selector(EurekaWhitespaceWorkaround.replaceNormalSpacesWithNonBreakingSpaces(textField:)), for: .editingChanged)
        cell.textField.addTarget(self, action: #selector(EurekaWhitespaceWorkaround.replaceNonBreakingSpacesWithNormalSpaces(textField:)), for: .editingDidEnd)
    }
    
    @objc private func replaceNormalSpacesWithNonBreakingSpaces(textField: UITextField) {
        if isDictation { return }
        
        let cursor = textField.selectedTextRange
        textField.text = textField.text?.replacingOccurrences(of: " ", with: REPLACING_CHAR)
        textField.selectedTextRange = cursor
    }
    
    @objc private func replaceNonBreakingSpacesWithNormalSpaces(textField: UITextField) {
        textField.text = textField.text?.replacingOccurrences(of: REPLACING_CHAR, with: " ")
    }
    
    @objc func keyboardModeChanged(notification: Notification) {
        let idSelector = #selector(getter: UILayoutGuide.identifier)
        guard textField?.textInputMode?.responds(to: idSelector) == true,
            let id = textField?.textInputMode?.perform(idSelector)?.takeUnretainedValue() as? String
        else {
            return
        }
        
        isDictation = id.contains(DICTATION_ID)
    }
}
