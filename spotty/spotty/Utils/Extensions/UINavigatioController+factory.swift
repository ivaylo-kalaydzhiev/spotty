//
//  UINavigatioController+factory.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import UIKit

extension UINavigationController {

    static func createReadyForTabBar(viewController: UIViewController,
                                     title: String,
                                     image: UIImage?,
                                     tag: Int = 1) -> UINavigationController {
        let navigator = UINavigationController(rootViewController: viewController)
        navigator.tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
        navigator.navigationBar.prefersLargeTitles = true
        return navigator
    }
}
