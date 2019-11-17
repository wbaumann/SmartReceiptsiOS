//
//  TabBarViewController.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 14.11.2019.
//  Copyright © 2019 Will Baumann. All rights reserved.
//

import Foundation

class TabBarViewController: UITabBarController, UITabBarControllerDelegate, Storyboardable {
    private var tabBarView: TabBar?
    
    override func viewDidLoad() {
        tabBarView = tabBar as? TabBar
        tabBar.unselectedItemTintColor = UIColor.black.withAlphaComponent(0.3)
        tabBar.tintColor = #colorLiteral(red: 0.2705882353, green: 0.1568627451, blue: 0.6235294118, alpha: 1)
        tabBarView?.updateIndicatorPosition(item: selectedViewController?.tabBarItem)
        tabBarView?.actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        delegate = self
    }
    
    @objc func didTapActionButton() {
        let tabWithAction = viewControllers?[selectedIndex] as? TabHasMainAction
        tabWithAction?.mainAction()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        UIView.animate(withDuration: DEFAULT_ANIMATION_DURATION) { [weak self] in
            self?.tabBarView?.updateIndicatorPosition(item: item)
        }
        
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        let tabWithAction = viewControllers?[index] as? TabHasMainAction
        guard let icon = tabWithAction?.actionIcon else { return }
        tabBarView?.actionButton.setImage(icon.withRenderingMode(.alwaysOriginal), for: .normal)
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

protocol TabHasMainAction {
    func mainAction()
    var actionIcon: UIImage { get }
}

extension TabHasMainAction {
    var actionIcon: UIImage {
        return #imageLiteral(resourceName: "white_plus")
    }
}
