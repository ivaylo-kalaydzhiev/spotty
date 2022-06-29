//
//  ShowsCoordinator.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 29.06.22.
//

import SFBaseKit

class ShowsCoordinator: Coordinator {
    
    // MARK: - Properties
    let navigationController: UINavigationController
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public Functions
    override func start() {
        startShowsScene()
    }
    
    // MARK: - Private Functions
    private func startShowsScene() {
        let viewModel = ShowsViewModel()
//        viewModel.delegate = self
        let viewController = ShowsViewController.create(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
