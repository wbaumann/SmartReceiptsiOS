//
//  TabBarViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14.11.2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        viewControllers = [
        ]

        tabBar.unselectedItemTintColor = UIColor.black.withAlphaComponent(0.3)
        tabBar.tintColor = #colorLiteral(red: 0.2705882353, green: 0.1568627451, blue: 0.6235294118, alpha: 1)
        (tabBar as? Tabbar)?.updateIndicatorPosition(item: tabBar.selectedItem)
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            (self?.tabBar as? Tabbar)?.updateIndicatorPosition(item: item)
        }
    }
}

class SimpleVC: UIViewController {
    var color: UIColor = .white
    
    
    init(_ color: UIColor) {
        super.init(nibName: nil, bundle: nil)
        self.color = color
        
        tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tabicon"), tag: 1)
        tabBarItem.imageInsets = .init(top: 16, left: 0, bottom: -16, right: 0)
        tabBarItem.selectedImage = #imageLiteral(resourceName: "selecte")
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = color
    }
}
