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
    
    func enableAutocompleteHelper() {
        autocompleteHelper = WBAutocompleteHelper(autocomplete: textField, useReceiptsHints: true)
        autocompleteHelper?.delegate = self
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
        autocompleteHelper?.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    func didSelect(value: String) {
        row.value = value
    }
    
}

@objc
protocol AutocompleteHelperDelegate {
    func didSelect(value: String)
}
