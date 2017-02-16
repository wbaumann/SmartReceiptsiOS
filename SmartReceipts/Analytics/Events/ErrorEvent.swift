//
//  ErrorEvent.swift
//  SmartReceipts
//
//  Created by Victor on 12/15/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

/// Default string keys for ErrorEvent class
fileprivate struct Constants {
    
    static let ErrorEventName = "Error"                     // error name
    static let ErrorEventDebugInfoDatapoint = "DebugInfo"   // datapoint key for error's debug info
    
    static let ExceptionEventName = "Exception"             // exception name
    static let ExceptionTraceDatapointName = "trace"        // datapoint key
    static let ExceptionDescriptionDatapointName = "description" // datapoint key
}

/// Class for registering errors
class ErrorEvent: Event {
    
    /// Detects is it an NSException or just an Error(NSError)
    let isException: Bool
    
    /// Creates ErrorEvent objects from given Error(NSError) object
    /// Also, ErrorEvent will grab some debug info when created: filename, function name, line
    ///
    /// - Parameters:
    ///   - error: Error(NSError) object
    ///   - file: Hidden, filename macros
    ///   - function: Hidden, function name macros
    ///   - line: Hidden, line number macros
    init(error: Error, file:String = #file, function:String = #function, line:Int = #line) {
        isException = false
        // create DataPoint with Error name and error's object
        let errorData = DataPoint(name: String(describing: type(of: error)), value: error)
        // Attaching some debug info: where this event has been created (filename, function, line)
        let errorLocationString = "file:\((file as NSString).lastPathComponent) function:\(function) line:\(line)"
        let debugData = DataPoint(name: Constants.ErrorEventDebugInfoDatapoint, value: errorLocationString)
        // initialize as OnError event
        super.init(category: Category.OnError, name: Constants.ErrorEventName, dataPoints: errorData, debugData)
    }
    
    /// Creates ErrorEvent objects from given NSException object
    ///
    /// - Parameter error: NSException object
    init(exception: NSException) {
        isException = true
        // create DataPoint with Exception name and exception stack trace        
        let exceptionDescription = DataPoint(name: Constants.ExceptionDescriptionDatapointName, value: exception.description)
        let callStackSymbols = DataPoint(name: Constants.ExceptionTraceDatapointName, value: exception.callStackSymbols.description)
        // initialize as OnError event
        super.init(category: Category.OnError, name: Constants.ExceptionEventName, dataPoints: exceptionDescription, callStackSymbols)
    }
}
