//
//  Log.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

class Log {
    enum Level: Int {
        case verbose = 0, debug, info, error, none
    }
    
    static var logLevel = Level.none
    
    class func debug<T>(_ object: T, file: String = #file, function: String = #function, line: Int = #line) {
        Logger.sharedInstance.log(object, file: file, function: function, line: line, level: .debug)
    }

    class func error<T>(_ object: T, file: String = #file, function: String = #function, line: Int = #line) {
        Logger.sharedInstance.log(object, file: file, function: function, line: line, level: .error)
    }

    class func addOutput(_ output: LogOutput) {
        Logger.sharedInstance.addOutput(output)
    }
}
