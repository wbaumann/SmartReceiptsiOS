//
//  GraphsViewController.swift
//  SmartReceipts
//
//  Created Bogdan Evsenev on 04.04.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import UIKit

class GraphsViewController: UIViewController {
    var viewModel: GraphsViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.moduleDidLoad()
    }
    
}
