//
//  TKTabBarViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/13/21.
//

import UIKit

class TKTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        tabBar.tintColor = UIColor.background
        let insets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
        let homeNavigationVC = UINavigationController(rootViewController: HomeViewController())
        homeNavigationVC.tabBarItem = UITabBarItem(title: TextManager.home, image: ImageManager.home, tag: 0)
        homeNavigationVC.tabBarItem.imageInsets = insets
        
        let categorygNavigationVC = UINavigationController(rootViewController: CategoriesViewController())
        categorygNavigationVC.tabBarItem = UITabBarItem(title: TextManager.category, image: ImageManager.category, tag: 1)
        categorygNavigationVC.tabBarItem.imageInsets = insets
        
        let personalNavigationVC = UINavigationController(rootViewController: PersonalViewController())
        personalNavigationVC.tabBarItem = UITabBarItem(title: TextManager.person, image: ImageManager.person, tag: 2)
        personalNavigationVC.tabBarItem.imageInsets = insets

         
        viewControllers = [homeNavigationVC, categorygNavigationVC, personalNavigationVC]
    }
    
}
