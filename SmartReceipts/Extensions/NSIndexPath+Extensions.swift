//
//  NSIndexPath+Extensions.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 20/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension IndexPath {
    func nextRow() -> IndexPath {
        return IndexPath(row: row + 1, section: section)
    }
    
    func previousRow() -> IndexPath {
        assert(row > 0)
        
        return IndexPath(row: row - 1, section: section)
    }
}
