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
    func insert(cell: UITableViewCell, afterCell after: UITableViewCell) {
        if let _ = indexPathForCell(cell) {
            return
        }
        
        guard let addAfterIndex = indexPathForCell(after) else {
            return
        }
        
        var insertIndex = addAfterIndex.nextRow()
        if let inlinedForIndex = presentingPickerForIndexPath where inlinedForIndex == addAfterIndex {
            insertIndex = insertIndex.nextRow()
        }
        
        let section = presentedSections[insertIndex.section]
        var cells = Array(section.cells!)
        cells.insert(cell, atIndex: insertIndex.row)
        presentedSections.replaceObjectAtIndex(insertIndex.section, withObject: InputCellsSection(title: section.title, cells: cells))
        
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([insertIndex], withRowAnimation: .Automatic)
        tableView.endUpdates()
    }
    
    func remove(cell: UITableViewCell) {
        guard let removeIndex = indexPathForCell(cell) else {
            return
        }
        
        let section = presentedSections[removeIndex.section]
        var cells = Array(section.cells!)
        cells.removeAtIndex(removeIndex.row)
        
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([removeIndex], withRowAnimation: .Automatic)
        presentedSections.replaceObjectAtIndex(removeIndex.section, withObject: InputCellsSection(title: section.title, cells: cells))
        tableView.endUpdates()
    }
}