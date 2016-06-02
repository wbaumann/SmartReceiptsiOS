//
//  InputCellsViewController.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 20/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation
import UIKit

extension InputCellsViewController {
    func addSectionForPresentation(section: InputCellsSection) {
        presentedSections.addObject(section)
        mapReturnKeys(section)
    }
    
    func insert(cell: UITableViewCell, afterCell after: UITableViewCell) {
        if let _ = indexPathForCell(cell) {
            return
        }
        
        guard let addAfterIndex = indexPathForCell(after) else {
            return
        }
        
        var insertIndex = addAfterIndex.nextRow()
        
        remapInlinePickers(insertIndex, add: true)
        
        if let inlinedForIndex = presentingPickerForIndexPath where inlinedForIndex == addAfterIndex {
            insertIndex = insertIndex.nextRow()
        }
        
        let section = presentedSections[insertIndex.section]
        var cells = Array(section.cells!)
        cells.insert(cell, atIndex: insertIndex.row)
        presentedSections.replaceObjectAtIndex(insertIndex.section, withObject: InputCellsSection(title: section.title, cells: cells))
        
        remapReturnKeys()
        
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([insertIndex], withRowAnimation: .Automatic)
        tableView.endUpdates()
    }
    
    func remove(cell: UITableViewCell) {
        guard let removeIndex = indexPathForCell(cell) else {
            return
        }
        
        remapInlinePickers(removeIndex, add: false)
        
        let section = presentedSections[removeIndex.section]
        var cells = Array(section.cells!)
        cells.removeAtIndex(removeIndex.row)
        
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([removeIndex], withRowAnimation: .Automatic)
        presentedSections.replaceObjectAtIndex(removeIndex.section, withObject: InputCellsSection(title: section.title, cells: cells))
        tableView.endUpdates()
    }
    
    private func remapInlinePickers(indexPath: NSIndexPath, add: Bool) {
        let mapping = inlinedPickers
        var changed = [NSIndexPath: UITableViewCell]()
        for (index, cell) in mapping {
            guard let index = index as? NSIndexPath else {
                continue
            }
            
            guard index.section == indexPath.section else {
                continue
            }
            
            guard index.row >= indexPath.row else {
                continue
            }
            
            inlinedPickers.removeObjectForKey(index)
            let mapped = add ? index.nextRow() : index.previousRow()
            changed[mapped] = cell as? UITableViewCell
        }
        
        inlinedPickers.addEntriesFromDictionary(changed)
    }
    
    private func mapReturnKeys(section: InputCellsSection) -> TextEntryCell? {
        var lastCell: TextEntryCell?
        for cell in section.cells {
            guard let textEntryCell = cell as? TextEntryCell else {
                continue
            }
            
            textEntryCell.entryField.delegate = self
            textEntryCell.entryField.returnKeyType = .Next
            lastCell = textEntryCell
        }
        
        return lastCell
    }
    
    private func remapReturnKeys() {
        var lastCell: TextEntryCell?
        for section in presentedSections {
            if let last = mapReturnKeys(section as! InputCellsSection) {
                lastCell = last
            }
        }
        
        guard let last = lastCell else {
            return
        }
        
        last.entryField.returnKeyType = .Done
    }
}