//
//  SceneDelegate.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = AuthManager.shared.isSignedIn
            ? TabBarViewController()
            : UINavigationController(rootViewController: WelcomeViewController())
//        window.rootViewController = DetailItemViewController()
        window.makeKeyAndVisible()
        self.window = window
    }
}
