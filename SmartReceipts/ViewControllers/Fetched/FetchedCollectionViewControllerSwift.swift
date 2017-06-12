//
//  FetchedCollectionViewControllerSwift.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 01/06/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Viperit

class FetchedCollectionViewControllerSwift: UserInterface, UITableViewDelegate, UITableViewDataSource, FetchedModelAdapterDelegate {
    
    let FETCHED_COLLECTION_CELL_ID = "FetchedCollectionTableViewControllerCellIdentifier"
    
    @IBOutlet var tableView: UITableView!
    
    var trip: WBTrip?
    
    var placeholderView: FetchedPlaceholderView?
    private(set) var placeholderTitle = ""
    
    var presentedObjects: FetchedModelAdapter? {
        didSet {
            checkNeedsPlaceholder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.placeholderView?.frame = self.view.bounds
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if presentedObjects == nil {
            fetchObjects()
        }
        checkNeedsPlaceholder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkNeedsPlaceholder()
    }
    
    func checkNeedsPlaceholder() {
        if let objects = presentedObjects {
            objects.allObjects().count > 0 ? hidePlaceholder() : showPlaceholder()
        } else {
            showPlaceholder()
        }
    }
    
    //MARK: UITableViewDelegate & UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FETCHED_COLLECTION_CELL_ID)!
        let object = objectAtIndexPath(indexPath)
        configureCell(cell, indexPath: indexPath, object: object!)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = objectAtIndexPath(indexPath)
            delete(object: model!, at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tapped = objectAtIndexPath(indexPath)
        tappedObject(tapped!, indexPath: indexPath)
    }
    
    func setPresentationCellNib(_ nib: UINib) {
        tableView.register(nib, forCellReuseIdentifier: FETCHED_COLLECTION_CELL_ID)
    }
    
    func configureCell(_ cell: UITableViewCell, indexPath: IndexPath, object: Any) {
        Logger.debug("LOGGER_DEBUG(configureCell:atIndexPath:\(indexPath)")
    }
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> Any? {
        return presentedObjects?.object(at: indexPath.row)
    }
    
    func indexOfObject(_ object: Any) -> UInt? {
        return presentedObjects?.index(for: object)
    }
    
    //MARK: Placeholder
    
    func hidePlaceholder() {
        placeholderView?.removeFromSuperview()
        placeholderView = nil
    }
    
    func showPlaceholder() {
        placeholderView?.removeFromSuperview()
        if (!placeholderTitle.isEmpty) {
            placeholderView = FetchedPlaceholderView(frame: tableView.frame, title: placeholderTitle)
            view.addSubview(placeholderView!)
        }
    }
    
    //MARK: Data
    
    func numberOfItems() -> Int {
        return presentedObjects == nil ? 0 : presentedObjects!.allObjects().count
    }

    func allObjects() -> [Any]? {
        return presentedObjects?.allObjects()
    }
    
    func fetchObjects() {
        let hud = PendingHUDView.showHUD(on: self.navigationController?.view ?? self.view)
        
        WBAppDelegate.instance().dataQueue().async { [weak self] in
            let objects = self?.createFetchedModelAdapter()
            objects?.delegate = self
            DispatchQueue.main.async {
                self?.presentedObjects = objects
                self?.tableView.reloadData()
                self?.contentChanged()
                hud?.hide()
            }
        }
    }
    
    func contentChanged() {
        Logger.debug("contentChanged")
    }
    
    func willChangeContent() {
        Logger.debug("willChangeContent")
        tableView.beginUpdates()
    }
    
    func createFetchedModelAdapter() -> FetchedModelAdapter? {
        Logger.debug("ABSTRACT: willChangeContent")
        return nil
    }
    
    func delete(object: Any!, at indexPath: IndexPath) {
        Logger.debug("deleteObject:atIndexPath:\(indexPath)")
    }
    
    func tappedObject(_ tapped: Any, indexPath: IndexPath) {
        Logger.debug("tappedObject:atIndexPath:\(indexPath)")
    }
    
    func didChangeContent() {
        Logger.debug("didChangeContent")
        tableView.endUpdates()
        contentChanged()
        checkNeedsPlaceholder()
    }
    
    func didInsert(_ object: Any!, at index: UInt) {
        Logger.debug("didInsert:atIndex:\(index)")
        tableView.insertRows(at: [IndexPath(row: Int(index), section: 0)], with: .automatic)
    }
    
    func didDelete(_ object: Any!, at index: UInt) {
        Logger.debug("didDelete:atIndex:\(index)")
        tableView.deleteRows(at: [IndexPath(row: Int(index), section: 0)], with: .automatic)
    }
    
    func didUpdate(_ object: Any!, at index: UInt) {
        Logger.debug("didUpdate:atIndex:\(index)")
        tableView.reloadRows(at: [IndexPath(row: Int(index), section: 0)], with: .automatic)
    }
    
    func didMove(_ object: Any!, from fromIndex: UInt, to toIndex: UInt) {
        Logger.debug("didDelete:fromIndex:\(fromIndex) toIndex:\(toIndex)")
        tableView.deleteRows(at: [IndexPath(row: Int(fromIndex), section: 0)], with: .automatic)
        tableView.insertRows(at: [IndexPath(row: Int(toIndex), section: 0)], with: .automatic)
    }
    
    func reloadData() {
        tableView.reloadData()
        contentChanged()
    }
}


