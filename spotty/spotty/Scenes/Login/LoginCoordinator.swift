//
//  LoginCoordinator.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 28.06.22.
//

import SFBaseKit

class LoginCoordinator: Coordinator {
    
    // MARK: - Properties
    private let navigationController: UINavigationController
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public Functions
    override func start() {
        startWelcomeScene()
    }
    
    // MARK: - Private Functions
    private func startWelcomeScene() {
        let viewModel = WelcomeViewModel()
        viewModel.delegate = self
        let viewController = WelcomeViewController.create(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func startAuthScene() {
        let viewModel = AuthViewModel()
        viewModel.delegate = self
        let viewController = AuthViewController.create(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func startCore() {
        let viewController = TabBarViewController()
        viewController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - CategoryViewModelCoordinatorDelegate
extension LoginCoordinator: WelcomeViewModelCoordinatorDelegate {
    
    func didFinishWelcomeScene() {
        startAuthScene()
    }
}

extension LoginCoordinator: AuthViewModelCoordinatorDelegate {
    
    func didFinishAuthScene() {
        startCore()
    }
}
