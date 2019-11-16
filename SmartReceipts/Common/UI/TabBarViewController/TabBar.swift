//
//  TabBar.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14.11.2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation

class TabBar: UITabBar {
    private let circleRadius: CGFloat = 37
    private let topOffset: CGFloat = 16
    private var shapeLayer: CALayer?
    
    private lazy var indicator: UIView = {
        let indicator = UIView(frame: .init(x: 0, y: 0, width: 40, height: 4))
        indicator.backgroundColor = #colorLiteral(red: 0.2705882353, green: 0.1568627451, blue: 0.6235294118, alpha: 1)
        indicator.layer.cornerRadius = 2
        return indicator
    }()
    
    private lazy var actionButton: UIButton = {
       let button = UIButton(type: .system)
        let size: CGFloat = 48
        button.bounds = .init(width: size, height: size)
        button.backgroundColor = #colorLiteral(red: 0.2705882353, green: 0.1568627451, blue: 0.6235294118, alpha: 1)
        button.layer.cornerRadius = size/2
        button.setImage(#imageLiteral(resourceName: "white_plus").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        addSubview(indicator)
        addSubview(actionButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        actionButton.center = .init(x: bounds.midX, y: actionButton.bounds.midY)
        updateIndicatorPosition(item: selectedItem)
    }
    
    func updateIndicatorPosition(item: UITabBarItem?) {
        guard let item = item, let index = items?.firstIndex(of: item) else { return }
        guard let itemsCount = items?.count, itemsCount > 0 else { return }
        let itemWidth = bounds.width/CGFloat(itemsCount)
        let centerX = itemWidth * CGFloat(index) + itemWidth/2
        let centerY = bounds.height - iOS10_safeAreaInsets().bottom
        indicator.center = CGPoint(x: centerX, y: centerY)
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOpacity = 0.16
        shapeLayer.shadowOffset = .zero
        shapeLayer.shadowRadius = 24
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSize = super.sizeThatFits(size)
        return .init(width: superSize.width, height: superSize.height + 20)
    }

    override func draw(_ rect: CGRect) {
        self.addShape()
    }

    private func createPath() -> CGPath {
        let path = UIBezierPath()
        let centerWidth = frame.width / 2
        
        let leftX = centerWidth - circleRadius
        let rightX = centerWidth + circleRadius
        let bottomY = topOffset + 40

        path.move(to: CGPoint(x: 0, y: topOffset))
        
        path.addLine(to: CGPoint(x: leftX, y: topOffset))
        path.addCurve(to: .init(x: leftX + 4.24, y: topOffset + 5.08), controlPoint1: .init(x: leftX + 2.65, y: topOffset), controlPoint2: .init(x: leftX + 5.48, y: topOffset + 2.86))
        path.addCurve(to: .init(x: leftX + 4.15, y: topOffset + 8), controlPoint1: .init(x: leftX + 4.19, y: topOffset + 6.04), controlPoint2: .init(x: leftX + 4.15, y: topOffset + 7.02))
        path.addCurve(to: CGPoint(x: centerWidth, y: bottomY), controlPoint1: CGPoint(x: leftX + 4.15, y: topOffset + 25.67), controlPoint2: .init(x: centerWidth - 18, y: bottomY))
        
        
        path.addCurve(to: .init(x: rightX - 4.15, y: topOffset + 8), controlPoint1: .init(x: centerWidth + 18, y: bottomY), controlPoint2: CGPoint(x: rightX - 4.15, y: topOffset + 25.67))
        path.addCurve(to: .init(x: rightX - 4.24, y: topOffset + 5.08), controlPoint1: .init(x: rightX - 4.15, y: topOffset + 7.02), controlPoint2: .init(x: rightX - 4.19, y: topOffset + 6.04))
        
        path.addCurve(to: .init(x: rightX, y: topOffset), controlPoint1: .init(x: rightX - 5.48, y: topOffset + 2.86), controlPoint2: .init(x: rightX - 2.65, y: topOffset))

        path.addLine(to: CGPoint(x: frame.width, y: topOffset))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.close()

        return path.cgPath
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if (point.x < abs(center.x - circleRadius) || point.x > abs(center.x + circleRadius)) && point.y < topOffset { return false }
        return true
    }
}
