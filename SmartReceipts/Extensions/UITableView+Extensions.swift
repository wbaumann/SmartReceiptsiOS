//
//  UITableView+Extensions.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/08/2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import UIKit

extension UITableView {
    func beginRefreshing(animated: Bool = true) {
        guard let refreshControl = self.refreshControl else { return }
        refreshControl.beginRefreshing()
        let offsetPoint = CGPoint(x: 0, y: -refreshControl.frame.size.height)
        setContentOffset(offsetPoint, animated: animated)
    }
}

