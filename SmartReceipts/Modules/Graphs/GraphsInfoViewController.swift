//
//  GraphsInfoViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01.06.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

class GraphsInfoViewController: PullUpController {
    @IBOutlet private weak var tableView: UITableView!
    
    var dataSource: GraphsInfoDataSource? {
        didSet {
            tableView.dataSource = dataSource
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.attach(to: self)
        view.layer.cornerRadius = 24
    }
    
    static func create() -> Self {
        let sb = UIStoryboard(name: String(describing: GraphsViewController.self), bundle: nil)
        return sb.instantiateViewController(withIdentifier: String(describing: Self.self)) as! Self
    }
    
    override var pullUpControllerPreferredSize: CGSize {
        return .init(width: UIScreen.main.bounds.width, height: 400)
    }
}

class GraphsInfoDataSource: NSObject, UITableViewDataSource {
    private let items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueCell(cell: GraphsInfoCell.self)
            .configure(item: items[indexPath.row])
    }
    
}

extension GraphsInfoDataSource {
    struct Item {
        let title: String
        let total: String
        let color: UIColor
    }
}
