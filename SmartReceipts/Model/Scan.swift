//
//  Scan.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/11/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import RxSwift
import SwiftyJSON

class Scan {
    private static let MINIMUM_DATE_CONFIDENCE = 0.4
    
    private(set) var image: UIImage!
    private(set) var merchant: String?
    private(set) var taxAmount: Double?
    private(set) var totalAmount: Double?
    private(set) var date: Date?
    
    init(image: UIImage) {
        self.image = image
    }
    
    init(json: JSON, image: UIImage) {
        self.image = image
        
        let recognition = json["recognition"].data["recognition_data"]
        self.merchant = recognition["merchantName"].data.string
        self.totalAmount = recognition["totalAmount"].data.double
        self.taxAmount = recognition["taxAmount"].data.double
    }
}

fileprivate extension JSON {
    var data: JSON {
        return self["data"]
    }
}
