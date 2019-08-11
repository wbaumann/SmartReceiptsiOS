//
//  Reusable+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 05/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ReusableCell: class {
    static var identifier: String { get }
}

extension ReusableCell {
    static var identifier: String {
        return String(describing: self.self)
    }
}

extension UITableViewCell: ReusableCell {}

extension UITableView {
    func register<Cell: UITableViewCell>(cell: Cell) {
        register(Cell.self, forCellReuseIdentifier: Cell.identifier)
    }
    
    func dequeueCell<Cell: UITableViewCell>(cell: Cell.Type) -> Cell {
        return dequeueReusableCell(withIdentifier: Cell.identifier) as! Cell
    }
}
