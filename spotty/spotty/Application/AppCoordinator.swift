//
//  AppCoordinator.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 28.06.22.
//

import SFBaseKit

class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow, navigationController: UINavigationController = UINavigationController()) {
        self.window = window
        self.navigationController = navigationController
        window.makeKeyAndVisible()
        window.rootViewController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    override func start() {
        startSplashScene()
    }
    
    private func startSplashScene() {
        let viewModel = SplashViewModel()
        viewModel.delegate = self
        let splashViewController = SplashViewController.create(viewModel: viewModel)
        navigationController.pushViewController(splashViewController, animated: true)
    }
    
    private func startWelcomeScene() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        addChildCoordinator(loginCoordinator)
        loginCoordinator.start()
    }
    
    private func startCoreScene() {
        let coreCoordinator = CoreCoordinator(navigationController: navigationController)
        addChildCoordinator(coreCoordinator)
        coreCoordinator.start()
    }
}

// MARK: - SplashViewModelCoordinatorDelegate
extension AppCoordinator: SplashViewModelCoordinatorDelegate {
    
    func didFinishSplashScene() {
        if AuthManager.shared.isSignedIn {
            startCoreScene()
        } else {
            startWelcomeScene()
        }
    }
}
