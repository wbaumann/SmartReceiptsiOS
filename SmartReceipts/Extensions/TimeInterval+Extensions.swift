//
//  TimeInterval+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 11/04/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Foundation

extension TimeInterval {
    static var second: TimeInterval { return 1           }
    static var minute: TimeInterval { return second * 60 }
    static var hour: TimeInterval   { return minute * 60 }
    static var day: TimeInterval    { return hour * 24   }
    static var week: TimeInterval   { return day * 7     }
    static var month: TimeInterval  { return day * 30    }
    static var year: TimeInterval   { return day * 365   }
}
