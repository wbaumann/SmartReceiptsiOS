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
        case VERBOSE = 0, DEBUG, INFO, ERROR, NONE
    }
    
    static var logLevel = Level.NONE
    
    class func debug<T>(object: T, file: String = #file, function: String = #function, line: Int = #line) {
        Logger.sharedInstance.log(object, file: file, function: function, line: line, level: .DEBUG)
    }

    class func error<T>(object: T, file: String = #file, function: String = #function, line: Int = #line) {
        Logger.sharedInstance.log(object, file: file, function: function, line: line, level: .ERROR)
    }

    class func addOutput(output: LogOutput) {
        Logger.sharedInstance.addOutput(output)
    }
}