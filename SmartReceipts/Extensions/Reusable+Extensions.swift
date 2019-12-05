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

protocol Reusable: class {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        return String(describing: self.self)
    }
}

extension UITableViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}

extension UITableView {
    func register<Cell: UITableViewCell>(cell: Cell.Type) {
        register(Cell.self, forCellReuseIdentifier: Cell.identifier)
    }
    
    func dequeueCell<Cell: UITableViewCell>(cell: Cell.Type) -> Cell {
        return dequeueReusableCell(withIdentifier: Cell.identifier) as! Cell
    }
    
    func register<HeaderFooter: UITableViewHeaderFooterView>(headerFooter: HeaderFooter.Type) {
        register(HeaderFooter.self, forHeaderFooterViewReuseIdentifier: HeaderFooter.identifier)
    }
    
    func dequeueHeaderFooter<HeaderFooter: UITableViewHeaderFooterView>(headerFooter: HeaderFooter.Type) -> HeaderFooter {
        return dequeueReusableHeaderFooterView(withIdentifier: HeaderFooter.identifier) as! HeaderFooter
    }
}
