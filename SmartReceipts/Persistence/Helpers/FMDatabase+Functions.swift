//
//  FMDatabase+Functions.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation
import FMDB

extension FMDatabase {
    func fetchSingle<T: FetchedModel>(_ query: DatabaseQueryBuilder, afterFetch: ((T) -> ())? = nil) -> T? {
        let resultSet = executeQuery(query.buildStatement(), withParameterDictionary: query.parameters())
        
        defer {
            resultSet?.close()
        }

        if !(resultSet?.next())! {
            return nil
        }
        
        let model = T()
        model?.loadData(from: resultSet)
        afterFetch?(model!)
        
        return model
    }
    
    func fetch<T: FetchedModel>(_ query: DatabaseQueryBuilder, inject: ((T) -> ())? = nil) -> [T] {
        var results = [T]()

        let resultSet = executeQuery(query.buildStatement(), withParameterDictionary: query.parameters())
        while (resultSet?.next())!  {
            let model = T()
            model?.loadData(from: resultSet)
            
            inject?(model!)
            
            results.append(model!)
        }
        
        resultSet?.close()
        
        return results
    }
    
    func executeUpdate(_ sql: String) -> Bool {
        return executeUpdate(sql, withParameterDictionary: [:])
    }
}
