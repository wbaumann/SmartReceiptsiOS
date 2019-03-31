//
//  Database.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation
import FMDB

extension Database {
    @objc func inDatabase(_ closure: @escaping (FMDatabase) -> ()) {
        databaseQueue.inDatabase() { database in
            closure(database)
        }
    }
}

enum DatabaseError: Error {
    case openFailed
}
