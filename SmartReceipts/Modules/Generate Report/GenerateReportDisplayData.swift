//
//  GenerateReportDisplayData.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 07/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation
import Viperit

final class GenerateReportDisplayData: DisplayData {
}

struct GenerateReportSelection {
    var fullPdfReport = false
    var pdfReportWithoutTable = false
    var csvFile = false
    var zipFiles = false
    var zipStampedJPGs = false
    
    var isValid: Bool {
        return fullPdfReport || pdfReportWithoutTable || csvFile || zipFiles || zipStampedJPGs
    }
}
