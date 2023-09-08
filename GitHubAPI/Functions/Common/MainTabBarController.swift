//
//  MainTabBarController.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/12.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViewController()
    }

    private func setUpViewController() {
        let searchVC = SearchViewController()
        searchVC.tabBarItem.title = "Search"
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        viewControllers = [searchVC]
    }
}
