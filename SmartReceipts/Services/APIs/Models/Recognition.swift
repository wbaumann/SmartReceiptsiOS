//
//  Recognition.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 19/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

struct Recognition: Codable {
    private(set) var id: String
    private(set) var status: String
    private(set) var s3path: String
    private(set) var result: RecognitonResult
    private(set) var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case s3path = "s3_path"
        case result = "data"
        case createdAt = "created_at_iso8601"
    }
}

struct RecognitionData: Codable {
    private(set) var totalAmount: DoubleData?
    private(set) var taxAmount: DoubleData?
    private(set) var date: DateData?
    private(set) var merchantName: StringData?
    private(set) var merchantAddress: StringData?
    private(set) var merchantCity: StringData?
    private(set) var merchantState: StringData?
    private(set) var merchantCountryCode: StringData?
    private(set) var merchantTypes: StringArrayData?
}

struct RecognitonResult: Codable {
    private(set) var data: RecognitionData
    private(set) var amount: Double?
    private(set) var tax: Double?
    
    enum CodingKeys: String, CodingKey {
        case data = "recognition_data"
        case amount
        case tax
    }
}


//MARK: Internal Models

struct DoubleData: Codable {
    private(set) var data: Double?
    private(set) var confidenceLevel: Double?
}

struct StringData: Codable {
    private(set) var data: String?
    private(set) var confidenceLevel: Double?
}

struct StringArrayData: Codable {
    private(set) var data: [String]?
    private(set) var confidenceLevel: Double?
}

fileprivate let MINIMUM_DATE_CONFIDENCE: Double = 0.4

struct DateData: Codable {
    private(set) var data: Date?
    private(set) var confidenceLevel: Double?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let confidenceLevel = try? container.decode(Double.self, forKey: .confidenceLevel),
            confidenceLevel >= MINIMUM_DATE_CONFIDENCE {
            self.confidenceLevel = confidenceLevel
            self.data = try? container.decode(Date.self, forKey: .data)
        }
    }
}


