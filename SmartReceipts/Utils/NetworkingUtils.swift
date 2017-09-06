//
//  NetworkingUtils.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

func endpoint(_ method: String) -> String {
    return "https://www.smartreceipts.co/api/\(method)"
}
