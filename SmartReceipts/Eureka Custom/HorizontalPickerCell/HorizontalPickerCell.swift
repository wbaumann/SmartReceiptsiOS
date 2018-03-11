//
//  HorizontalPicker.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 08/03/2018.
//  Copyright © 2018 Will Baumann. All rights reserved.
//

import Eureka

public class HorizontalPickerCell: Cell<Int>, CellType, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let cellName = "HorizontalPickerItemCell"
    
    public override func setup() {
        super.setup()
        height = { 56 }
        
        let cellNib = UINib(nibName: cellName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellName)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    public override func update() {
        super.update()
    }
    
    fileprivate func row() -> HorizontalPickerRow {
        return (row as! HorizontalPickerRow)
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        row().value = indexPath.row
        UIImpactFeedbackGenerator().impactOccurred()
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
        if let itemCell = cell as? HorizontalPickerItemCell {
            itemCell.configureFor(any: row().options[indexPath.row])
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return row().options.count
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = Bundle.main.loadNibNamed(cellName, owner: nil, options: nil)?.first as? HorizontalPickerItemCell else {
            return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
        }
        let option = row().options[indexPath.row]
        return CGSize(width: cell.widthFor(any: option), height: collectionView.bounds.height)
    }
}


public final class HorizontalPickerRow: Row<HorizontalPickerCell>, RowType {
    var options: [Any] = [] {
        didSet {
            cell.collectionView.reloadData()
        }
    }
    
    public required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<HorizontalPickerCell>(nibName: "HorizontalPickerCell")
    }
    
}
