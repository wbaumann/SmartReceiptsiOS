//
//  ConsoleOutput.swift
//  SmartReceipts
//
//  Created by Jaanus Siim on 31/05/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

open class ConsoleOutput: LogOutput {
    public init() {
        
    }
    
    open func printMessage(_ message: String) {
        print(message)
    }
}
