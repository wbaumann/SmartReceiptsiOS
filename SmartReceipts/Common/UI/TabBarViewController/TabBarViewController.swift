//
//  TabBarViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14.11.2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation

class TabBarViewController: UITabBarController, UITabBarControllerDelegate, Storyboardable {
    
    override func viewDidLoad() {
        tabBar.unselectedItemTintColor = UIColor.black.withAlphaComponent(0.3)
        tabBar.tintColor = #colorLiteral(red: 0.2705882353, green: 0.1568627451, blue: 0.6235294118, alpha: 1)
        (tabBar as? TabBar)?.updateIndicatorPosition(item: selectedViewController?.tabBarItem)
        delegate = self
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        UIView.animate(withDuration: DEFAULT_ANIMATION_DURATION) { [weak self] in
            (self?.tabBar as? TabBar)?.updateIndicatorPosition(item: item)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return viewController.tabBarItem.tag > Constants.unselectableTag
    }
}

extension TabBarViewController {
    enum Constants {
        static let unselectableTag = -1
    }
}

