//
//  FMDatabase+Functions.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension FMDatabase {
    func fetch<T: FetchedModel>(type: T.Type, query: DatabaseQueryBuilder) -> [T] {
        return []
    }
}