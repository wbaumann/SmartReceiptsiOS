//
//  NSIndexPath+Extensions.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 20/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension NSIndexPath {
    func nextRow() -> NSIndexPath {
        return NSIndexPath(forRow: row + 1, inSection: section)
    }
    
    func previousRow() -> NSIndexPath {
        assert(row > 0)
        
        return NSIndexPath(forRow: row - 1, inSection: section)
    }
}