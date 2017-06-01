//
//  InputCellsViewControllerSwift.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Viperit

class InputCellsViewControllerSwift: UserInterface, UITableViewDelegate,
UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var presentedSections = [InputCellsSection]()
    var containNextEditSearchInsideSection = false
    var lastEntryCell: TextEntryCell?
    var presentingPickerForIndexPath: IndexPath?
    var activeFieldInputValidation: InputValidation?
    var inlinedPickers = [IndexPath : UITableViewCell]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: TableView Delegate & Datasource

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.presentedSections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(presentedSections[section].numberOfCells())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = presentedSections[indexPath.section]
        let cell = section.cell(at: UInt(indexPath.row))!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        if hasInlinedPickerAttachedAtIndexPath(indexPath) {
            handleInlinePickerForIndexPath(indexPath)
            return
        }
        
        let undefCell = cellAtIndexPath(indexPath)
        if let cell = undefCell as? TextEntryCell {
            if cell.entryField.isEnabled {
                cell.entryField.becomeFirstResponder()
            }
        } else if let cell = undefCell as? SwitchControlCell {
            cell.setSwitchOn(!cell.isSwitchOn(), animated: true)
        } else {
            tappedCell(undefCell, at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = cellAtIndexPath(indexPath)
        return cell.frame.height
    }
    
    func cellAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        let section = presentedSections[indexPath.section]
        return section.cell(at: UInt(indexPath.row))!
    }
    
    
    //MARK: Class functions
    func nextEntryCellAfterIndexPath(_ indexPath: IndexPath) -> TextEntryCell? {
        for section in 0..<self.presentedSections.count {
            let cellsSection = presentedSections[section]
            for row in 0..<cellsSection.numberOfCells() {
                if let cell = cellsSection.cell(at: row) as? TextEntryCell {
                    return cell
                }
            }
            if containNextEditSearchInsideSection {
                break
            }
        }
        return nil
    }
    
    func addInlinedPickerCell(_ cell: UITableViewCell,forCell: UITableViewCell) {
        if let indexPath = indexPathForCell(forCell) {
            inlinedPickers[indexPath] = cell
        }
    }
    
    func indexPathForCell(_ cell: UITableViewCell) -> IndexPath? {
        for section in 0..<self.presentedSections.count {
            let cellsSection = presentedSections[section]
            for row in 0..<cellsSection.numberOfCells() {
                let checked = cellsSection.cell(at: row)
                if cell == checked {
                    return IndexPath(row: Int(row), section: section)
                }
            }
        }
        return nil
    }

    func hasInlinedPickerAttachedAtIndexPath(_ indexPath: IndexPath) -> Bool {
        let checked = indexPathWithoutPossiblePickerOffset(indexPath)
        return inlinedPickers[checked] != nil
    }
    
    func indexPathWithoutPossiblePickerOffset(_ indexPath: IndexPath) -> IndexPath {
        var result = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        if let ip = presentingPickerForIndexPath {
            if (ip.section != indexPath.section || ip.row >= indexPath.row) {
                result = indexPath
            }
        }
        return result
    }

    func handleInlinePickerForIndexPath(_ indexPath: IndexPath) {
        tableView.beginUpdates()
        let handled = indexPathWithoutPossiblePickerOffset(indexPath)

        if let previous = presentingPickerForIndexPath {
            dismissPickerForIndexPath(previous)
        
            if (handled != previous) {
                presentPickerForIndexPath(handled)
            }
        }
        tableView.endUpdates()
    }
    
    func presentPickerForIndexPath(_ indexPath: IndexPath) {
        UIApplication.dismissKeyboard()
        
        let pickerCell = self.inlinedPickers[indexPath]
        let insertPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
        
        let section = presentedSections[indexPath.section]
        section.insertCell(pickerCell!, at: indexPath.row)
        tableView.insertRows(at: [insertPath], with: .fade)

        presentingPickerForIndexPath = indexPath
    }

    func dismissPickerForIndexPath(_ indexPath: IndexPath) {
        let removePath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
        let section = presentedSections[removePath.section]
        section.removeCell(at: removePath.row)
        
        tableView.deleteRows(at: [removePath], with: .fade)
        
        presentingPickerForIndexPath = nil
    }
    
    func tappedCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        Logger.debug("tappedCell:atIndexPath:\(indexPath)")
    }

    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let cell = textField.superview as? UITableViewCell else { return true }
        
        let cellIndexPath = tableView.indexPath(for: cell)
        if let nextCell = nextEntryCellAfterIndexPath(cellIndexPath!) {
            let indexPath = indexPathForCell(nextCell)
            nextCell.entryField.becomeFirstResponder()
            tableView.scrollToRow(at: indexPath!, at: .none, animated: true)
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cell = textField.superview as? TitledAutocompleteEntryCell else { return }
        cell.autocompleteHelper.textFieldDidEndEditing(textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let cell = textField.superview as? TitledAutocompleteEntryCell {
            cell.autocompleteHelper.textFieldDidEndEditing(textField)
        }
        
        if let cell = textField.superview as? TextEntryCell {
            activeFieldInputValidation = cell.inputValidation
        } else {
            activeFieldInputValidation = nil
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let cell = textField.superview as? TitledAutocompleteEntryCell {
            cell.autocompleteHelper.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        
        if let nsString = textField.text as NSString? {
            if (activeFieldInputValidation == nil) || nsString.length == 0 {
                return true
            }
            let validate = nsString.replacingCharacters(in: range, with: string)
            return activeFieldInputValidation?.isValidInput(validate) ?? true
        } else {
            return false
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presentedSections[section].sectionTitle
    }
}


extension InputCellsViewControllerSwift {
    func addSectionForPresentation(_ section: InputCellsSection) {
        presentedSections.append(section)
        _ = mapReturnKeys(section)
    }
    
    func insert(_ cell: UITableViewCell, afterCell after: UITableViewCell) {
        if let _ =  indexPathForCell(cell) {
            return
        }
        
        guard let addAfterIndex = indexPathForCell(after) else {
            return
        }
        
        var insertIndex = addAfterIndex.nextRow()
        
        remapInlinePickers(insertIndex, add: true)
        
        if let inlinedForIndex = presentingPickerForIndexPath, inlinedForIndex == addAfterIndex {
            insertIndex = insertIndex.nextRow()
        }
        
        let section = presentedSections[insertIndex.section]
        var cells = Array((section as AnyObject).cells!)
        cells.insert(cell, at: insertIndex.row)
        
        let newSection = InputCellsSection(title: (section as AnyObject).title, cells: cells)
        presentedSections[insertIndex.section] = newSection
        
        remapReturnKeys()
        
        tableView.beginUpdates()
        tableView.insertRows(at: [insertIndex], with: .automatic)
        tableView.endUpdates()
    }
    
    func remove(_ cell: UITableViewCell) {
        guard let removeIndex = indexPathForCell(cell) else {
            return
        }
        
        remapInlinePickers(removeIndex, add: false)
        
        let section = presentedSections[removeIndex.section]
        var cells = Array((section as AnyObject).cells!)
        cells.remove(at: removeIndex.row)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [removeIndex], with: .automatic)
        
        let newSection = InputCellsSection(title: (section as AnyObject).title, cells: cells)
        presentedSections[removeIndex.section] = newSection
        
        tableView.endUpdates()
    }
    
    fileprivate func remapInlinePickers(_ indexPath: IndexPath, add: Bool) {
        let mapping = inlinedPickers
        var changed = [IndexPath: UITableViewCell]()
        for (index, cell) in mapping {
            guard index.section == indexPath.section else {
                continue
            }
            
            guard index.row >= indexPath.row else {
                continue
            }
            
            inlinedPickers.removeValue(forKey: index)
            let mapped = add ? index.nextRow() : index.previousRow()
            changed[mapped] = cell
        }
        
        (inlinedPickers as? NSMutableDictionary)?.addEntries(from: changed)
    }
    
    fileprivate func mapReturnKeys(_ section: InputCellsSection) -> TextEntryCell? {
        var lastCell: TextEntryCell?
        for cell in section.cells {
            guard let textEntryCell = cell as? TextEntryCell else {
                continue
            }
            
            textEntryCell.entryField.delegate = self
            textEntryCell.entryField.returnKeyType = .next
            lastCell = textEntryCell
        }
        
        return lastCell
    }
    
    fileprivate func remapReturnKeys() {
        var lastCell: TextEntryCell?
        for section in presentedSections {
            if let last = mapReturnKeys(section) {
                lastCell = last
            }
        }
        
        guard let last = lastCell else {
            return
        }
        
        last.entryField.returnKeyType = .done
    }
}
