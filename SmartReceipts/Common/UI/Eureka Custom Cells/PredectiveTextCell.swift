//
//  PredectiveTextCell.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 23/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import UIKit
import Eureka

public final class PredectiveTextRow: FieldRow<PredectiveTextCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public class PredectiveTextCell: TextCell, AutocompleteHelperDelegate {
    private var autocompleteHelper: WBAutocompleteHelper?
    
    func enableAutocompleteHelper(useReceiptsHints: Bool) {
        if !containsCustomKeyboards() {
            autocompleteHelper = WBAutocompleteHelper(autocomplete: textField, useReceiptsHints: useReceiptsHints)
            autocompleteHelper?.delegate = self
        }
    }
    
    public override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        autocompleteHelper?.textFieldDidEndEditing(textField)
    }
    
    public override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        autocompleteHelper?.textFieldDidBeginEditing(textField)
    }
    
    public override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let should = super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        autocompleteHelper?.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        return should
    }
    
    func didSelect(value: String) {
        let newValue = EurekaWhitespaceWorkaround.replaceNormalSpacesWithNonBreakingSpaces(value)
        row.value = newValue
        row.updateCell()
    }
    
    // Checking if user have custom keyboards to avoid issue with suggestion view and custom keyboard views conflict.
    private func containsCustomKeyboards() -> Bool {
        guard let keyboards = UserDefaults.standard.array(forKey: "AppleKeyboards") as? [String] else { return false }
        for keyboard in keyboards {
            if !keyboard.contains("@") {
                return true
            }
        }
        return false
    }
    
}

@objc
protocol AutocompleteHelperDelegate {
    func didSelect(value: String)
}
