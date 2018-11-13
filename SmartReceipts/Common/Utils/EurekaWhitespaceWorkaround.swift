//
//  EurekaWhitespaceWorkaround.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 13/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation
import Eureka

final class EurekaWhitespaceWorkaround {
    
    static func configureTextCells() {
        let workaround = EurekaWhitespaceWorkaround()
        TextRow.defaultCellSetup = { cell, row in
            // the workaround object is retained here on purpose
            workaround.configureWhiteSpaceWorkaround(forTextCell: cell)
        }
    }
    
    func configureWhiteSpaceWorkaround(forTextCell cell: TextCell) {
        cell.textField.addTarget(self, action: #selector(EurekaWhitespaceWorkaround.replaceNormalSpacesWithNonBreakingSpaces(textField:)), for: .editingChanged)
        cell.textField.addTarget(self, action: #selector(EurekaWhitespaceWorkaround.replaceNonBreakingSpacesWithNormalSpaces(textField:)), for: .editingDidEnd)
    }
    
    @objc private func replaceNormalSpacesWithNonBreakingSpaces(textField: UITextField) {
        let cursor = textField.selectedTextRange
        textField.text = textField.text?.replacingOccurrences(of: " ", with: "\u{00a0}")
        textField.selectedTextRange = cursor
    }
    
    @objc private func replaceNonBreakingSpacesWithNormalSpaces(textField: UITextField) {
        textField.text = textField.text?.replacingOccurrences(of: "\u{00a0}", with: " ")
    }
}
