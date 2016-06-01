//
//  FMDatabase+Functions.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

extension FMDatabase {
    func fetch<T: FetchedModel>(query: DatabaseQueryBuilder, inject: ((T) -> ())? = nil) -> [T] {
        var results = [T]()

        let resultSet = executeQuery(query.buildStatement(), withParameterDictionary: query.parameters())
        while resultSet.next()  {
            let model = T()
            model.loadDataFromResultSet(resultSet)
            
            inject?(model)
            
            results.append(model)
        }
        
        return results
    }
}