//
//  MainTabBarController.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/28/24.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        let nav1 = UINavigationController(rootViewController: MainViewController())
        let nav2 = UINavigationController(rootViewController: SettingViewController())
        
        nav1.tabBarItem.title = "검색"
        nav1.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        nav1.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.fill")
        
        nav2.tabBarItem.title = "설정"
        nav2.tabBarItem.image = UIImage(systemName: "person")
        nav2.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        setViewControllers([nav1, nav2], animated: true)
    }
    
}
