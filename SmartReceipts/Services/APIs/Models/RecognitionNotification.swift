//
//  RecognitionNotification.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 20/11/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

struct RecognitionNotification: Codable {
    private(set) var code: Int
    private(set) var message: String
}
