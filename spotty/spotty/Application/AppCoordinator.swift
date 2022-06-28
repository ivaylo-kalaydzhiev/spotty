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
        //        navigationController.setupNavigationBarAppearance()
        window.makeKeyAndVisible()
    }
    
    override func start() {
        startSplashScene()
    }
    
    private func startSplashScene() {
        let viewModel = SplashViewModel()
        viewModel.delegate = self
        let splashViewController = SplashViewController.create(viewModel: viewModel)
        window.rootViewController = splashViewController
    }
    
    private func startWelcomeScene() {
        window.rootViewController = navigationController
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        addChildCoordinator(loginCoordinator)
        loginCoordinator.start()
    }
    
    private func startCoreScene() {
        window.rootViewController = navigationController
        let coreCoordinator = CoreCoordinator(navigationController: navigationController)
        addChildCoordinator(coreCoordinator)
        coreCoordinator.start()
    }
    
}

// MARK: - SplashViewModelCoordinatorDelegate
extension AppCoordinator: SplashViewModelCoordinatorDelegate {
    
    func didFinishSplashScene() {
        _ = AuthManager.shared.isSignedIn
            ? startCoreScene()
            : startWelcomeScene()
    }
}
