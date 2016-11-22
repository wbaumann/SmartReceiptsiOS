//
//  Logger.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

internal class Logger {
    internal static let sharedInstance = Logger()
    fileprivate var outputs = [LogOutput]()
    
    internal func addOutput(_ output:LogOutput) {
        outputs.append(output)
    }
    
    internal func log<T>(_ object: T, file: String, function: String, line: Int, level: Log.Level) {
        if level.rawValue < Log.logLevel.rawValue {
            return
        }
        
        let time = timeFormatter.string(from: Date())
        let levelString = levelToString(level)
        let fileURL = URL(fileURLWithPath: file, isDirectory: false)
        let cleanedFile = fileURL.lastPathComponent ?? "-"
        let message = "\(time) - \(levelString) - \(cleanedFile).\(function):\(line) - \(object)"
        
        for output: LogOutput in outputs {
            output.printMessage(message)
        }
    }
    
    fileprivate func levelToString(_ level: Log.Level) -> String {
        switch(level) {
        case .error:
            return "E"
        case .info:
            return "I"
        case .debug:
            return "D"
        case .verbose:
            return "V"
        default:
            return ""
        }
    }
    
    fileprivate lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}
