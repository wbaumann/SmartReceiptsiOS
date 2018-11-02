//
//  NetworkingUtils.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05/09/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

func endpoint(_ method: String) -> String {
    let prefix = FeatureFlags.useProdEndpoints.isEnabled ? "www" : "beta"
    return "https://\(prefix).smartreceipts.co/api/\(method)"
}
