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
    func addSectionForPresentation(_ section: InputCellsSection) {
        presentedSections.add(section)
        _ = mapReturnKeys(section)
    }
    
    func insert(_ cell: UITableViewCell, afterCell after: UITableViewCell) {
        if let _ = indexPath(for: cell) {
            return
        }
        
        guard let addAfterIndex = indexPath(for: after) else {
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
        presentedSections.replaceObject(at: insertIndex.section, with: InputCellsSection(title: (section as AnyObject).title, cells: cells))
        
        remapReturnKeys()
        
        tableView.beginUpdates()
        tableView.insertRows(at: [insertIndex], with: .automatic)
        tableView.endUpdates()
    }
    
    func remove(_ cell: UITableViewCell) {
        guard let removeIndex = indexPath(for: cell) else {
            return
        }
        
        remapInlinePickers(removeIndex, add: false)
        
        let section = presentedSections[removeIndex.section]
        var cells = Array((section as AnyObject).cells!)
        cells.remove(at: removeIndex.row)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [removeIndex], with: .automatic)
        presentedSections.replaceObject(at: removeIndex.section, with: InputCellsSection(title: (section as AnyObject).title, cells: cells))
        tableView.endUpdates()
    }
    
    fileprivate func remapInlinePickers(_ indexPath: IndexPath, add: Bool) {
        let mapping = inlinedPickers
        var changed = [IndexPath: UITableViewCell]()
        for (index, cell) in mapping {
            guard let index = index as? IndexPath else {
                continue
            }
            
            guard index.section == indexPath.section else {
                continue
            }
            
            guard index.row >= indexPath.row else {
                continue
            }
            
            inlinedPickers.removeObject(forKey: index)
            let mapped = add ? index.nextRow() : index.previousRow()
            changed[mapped] = cell as? UITableViewCell
        }
        
        inlinedPickers.addEntries(from: changed)
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
            if let last = mapReturnKeys(section as! InputCellsSection) {
                lastCell = last
            }
        }
        
        guard let last = lastCell else {
            return
        }
        
        last.entryField.returnKeyType = .done
    }
}
