//
//  PDFReportTable.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/12/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Foundation

fileprivate let MINIMUM_COLUMN_WIDTH: CGFloat = 24

class PDFReportTable: UIView {
    @IBOutlet var headerRowPrototype: TableHeaderRow!
    @IBOutlet var rowOnePrototype: TableContentRow!
    @IBOutlet var rowTwoPrototype: TableContentRow!
    @IBOutlet var footerRowPrototype: TableFooterRow!
    
    var title: String?
    var rows = [[String]]()
    var columns = [String]()
    var footers = [String]()
    var rowsAdded: Int = 0
    var rowToStart: Int = 0
    var tableHeaderAdded = false
    var hasTooManyColumnsToFitWidth = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        headerRowPrototype.removeFromSuperview()
        rowOnePrototype.removeFromSuperview()
        rowTwoPrototype.removeFromSuperview()
        footerRowPrototype.removeFromSuperview()
        
        clipsToBounds = true
        headerRowPrototype.contentLabel?.font = PDFFontStyle.defaultBold.font
    }
    
    func append(values: [String]) {
        rows.append(values)
    }
    
    func appendRow(row array: [String], coloumnsWidths: [CGFloat], usingPrototype: TableContentRow, yOffset: CGFloat) -> CGFloat {
        let height = maxHeightForRow(array: array, widths: coloumnsWidths, prototype: usingPrototype)
        var xOffset: CGFloat = 0
        
        for i in 0..<array.count {
            let value = array[i]
            let cell = duplicate(view: usingPrototype) as? TableContentRow
            cell?.setValue(value)
            let width = coloumnsWidths[i]
            var cellFrame = cell!.frame
            cellFrame.origin.x = xOffset
            cellFrame.origin.y = yOffset
            cellFrame.size.width = width
            cellFrame.size.height = height
            cell?.frame = cellFrame
            addSubview(cell!)
            xOffset += width
        }
        return yOffset + height
    }
    
    func setTable(title: String, yOffset: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect.zero)
        label.frame.origin.y = yOffset
        label.font = PDFFontStyle.defaultBold.font
        label.textColor = AppTheme.reportPDFStyleColor
        label.text = title
        label.sizeToFit()
        addSubview(label)
        return yOffset + label.bounds.height
    }
    
    func buildTable(availableSpace: CGFloat) -> Bool {
        var columnsWidth = [CGFloat]()
        var titleWidth = [CGFloat]()
        
        for column in 0..<columns.count {
            columnsWidth.append(maxWidthOfColumn(column))
            let w = CGFloat(ceilf(Float(headerRowPrototype.widthFor(value: columns[column]))))
            titleWidth.append(w)
        }
        
        columnsWidth = divideRemainingWidth(columns: columnsWidth, titleWidth: titleWidth)
        
        var yOffset: CGFloat = 10
        // Don't add header on view where already added
        // Happens when we decide that not enough rows in page and push all to next page.
        // In that case original table is reused, just additional rows added
        
        if let tableTitle = title {
            yOffset = setTable(title: tableTitle, yOffset: yOffset) + 8
            title = nil
        }
        
        if !tableHeaderAdded {
            yOffset = appendRow(row: columns, coloumnsWidths: columnsWidth, usingPrototype: headerRowPrototype, yOffset: yOffset)
            tableHeaderAdded = true
            setFrameHeight(to: frame.height)
        } else {
            yOffset = frame.height
        }
        
        for row in rowToStart..<rows.count {
            var prototype: TableContentRow!
            if row % 2 == 0 {
                prototype = rowOnePrototype
            } else {
                prototype = rowTwoPrototype
            }
            
            let height = maxHeightForRow(array: rows[row], widths: columnsWidth, prototype: prototype)
            if yOffset + height > availableSpace {
                rowsAdded = row
                return false
            }
            yOffset = appendRow(row: rows[row], coloumnsWidths: columnsWidth, usingPrototype: prototype, yOffset: yOffset)
        }
        yOffset = appendRow(row: footers, coloumnsWidths: columnsWidth, usingPrototype: footerRowPrototype, yOffset: yOffset)
        setFrameHeight(to: yOffset)
        return true
    }
    
    func maxHeightForRow(array: [String], widths: [CGFloat], prototype: TableContentRow) -> CGFloat {
        var maxHeight: CGFloat = 0
        for column in 0..<array.count {
            let value = array[column]
            let width = widths[column]
            maxHeight = max(maxHeight, prototype.heightFor(value: value, width: width))
        }
        return maxHeight
    }
    
    func maxWidthOfColumn(_ column: Int) -> CGFloat {
        var maxWidth: CGFloat = 0
        let title = columns[column]
        maxWidth = max(maxWidth, headerRowPrototype.widthFor(value: title))
        for row in rows {
            let value = row[column]
            maxWidth = max(maxWidth, rowOnePrototype.widthFor(value: value))
        }
        if !footers.isEmpty {
            maxWidth = max(maxWidth, footerRowPrototype.widthFor(value: footers[column]))
        }
        return CGFloat(ceilf(Float(maxWidth)))
    }
    
    // MARK: Private
    
    private func setFrameHeight(to height: CGFloat) {
        var myFrame = frame
        myFrame.size.height = height
        frame = myFrame
    }
    
    private func duplicate(view: UIView) -> UIView {
        let data = NSKeyedArchiver.archivedData(withRootObject: view)
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! UIView
    }
    
    private func divideRemainingEqually(columns: [CGFloat], columnsWidth: CGFloat) -> [CGFloat] {
        var reminder = frame.width - columnsWidth
        var toAdd = CGFloat(ceilf(Float(reminder)/Float(columns.count)))
        var added = [CGFloat]()
        for index in 0..<columns.count {
            let number = columns[index]
            if toAdd > reminder {
                toAdd = reminder
            }
            added.append(number + toAdd)
            reminder -= toAdd
        }
        return added
    }
    
    private func divideRemainingWidth(columns: [CGFloat], titleWidth: [CGFloat]) -> [CGFloat] {
        var result = columns
        let width = sum(array: columns)
        if width <= frame.width {
            result = divideRemainingEqually(columns: columns, columnsWidth: width)
        } else {
            result = fitColumnsWidth(columns: columns, titleWidths: titleWidth)
        }
        return result
    }
    
    
    private func fitColumnsWidth(columns: [CGFloat], titleWidths: [CGFloat]) -> [CGFloat] {
        let indexesToModify = NSMutableIndexSet()
        let indexesNotToModify = NSMutableIndexSet()
        for index in 0..<columns.count {
            if canSqueezeColumn(title: self.columns[index]) {
                indexesToModify.add(index)
            } else {
                indexesNotToModify.add(index)
            }
        }
        let totalWidthOfNotModified = sum(array: objectcsAt(indexes: indexesNotToModify, in: columns))
        let modifiedTitleWidths = sum(array: objectcsAt(indexes: indexesToModify, in: titleWidths))
        let sumModifiedColumns = sum(array: objectcsAt(indexes: indexesToModify, in: columns))
        let totalWidthOfModified = sumModifiedColumns == 0 ? 1 : sumModifiedColumns
        
        let spaceToDivide = frame.width - totalWidthOfNotModified - modifiedTitleWidths
        
        var modifiedColumns = [CGFloat]()
        for i in 0..<columns.count {
            if indexesNotToModify.contains(i) {
                modifiedColumns.append(columns[i])
                continue
            }
            let columnWidth = columns[i]
            let percent = columnWidth/totalWidthOfModified
            let titleWidth = titleWidths[i]
            let squeezedTitleWidth = titleWidth + CGFloat(floorf(Float(spaceToDivide * percent)))
            
            // check if all the columns can be placed within the table (if there enough available width)
            if squeezedTitleWidth < MINIMUM_COLUMN_WIDTH {
                Logger.warning("Too many table columns to fit this page")
                hasTooManyColumnsToFitWidth = true
            }
            modifiedColumns.append(squeezedTitleWidth)
        }
        
        return modifiedColumns
    }
    
    
    private func sum(array: [CGFloat]) -> CGFloat {
        var result: CGFloat = 0
        for i in 0..<array.count {
            result += array[i]
        }
        return result
    }
    
    private func objectcsAt(indexes: NSMutableIndexSet, in array: [CGFloat]) -> [CGFloat] {
        var result = [CGFloat]()
        indexes.forEach { index in
            if index < array.count {
                result.append(array[index])
            }
        }
        return result
    }
    
    private func canSqueezeColumn(title: String) -> Bool {
        return LocalizedString("receipt.column.comment") == title ||
            LocalizedString("receipt.column.name") == title ||
            LocalizedString("receipt.column.report.comment") == title ||
            LocalizedString("receipt.column.blank.column") == title
    }
    
}
