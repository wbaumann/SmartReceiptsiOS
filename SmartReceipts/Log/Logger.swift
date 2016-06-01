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
    private var outputs = [LogOutput]()
    
    internal func addOutput(output:LogOutput) {
        outputs.append(output)
    }
    
    internal func log<T>(object: T, file: String, function: String, line: Int, level: Log.Level) {
        if level.rawValue < Log.logLevel.rawValue {
            return
        }
        
        let time = timeFormatter.stringFromDate(NSDate())
        let levelString = levelToString(level)
        let fileURL = NSURL(fileURLWithPath: file, isDirectory: false)
        let cleanedFile = fileURL.lastPathComponent ?? "-"
        let message = "\(time) - \(levelString) - \(cleanedFile).\(function):\(line) - \(object)"
        
        for output: LogOutput in outputs {
            output.printMessage(message)
        }
    }
    
    private func levelToString(level: Log.Level) -> String {
        switch(level) {
        case .ERROR:
            return "E"
        case .INFO:
            return "I"
        case .DEBUG:
            return "D"
        case .VERBOSE:
            return "V"
        default:
            return ""
        }
    }
    
    private lazy var timeFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}