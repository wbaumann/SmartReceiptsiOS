//
//  Currency+Extensions.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

func == (lhs: Currency, rhs: Currency) -> Bool {
    return lhs.code == rhs.code
}
