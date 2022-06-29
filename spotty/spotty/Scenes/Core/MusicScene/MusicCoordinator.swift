//
//  MusicCoordinator.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 29.06.22.
//

import SFBaseKit

class MusicCoordinator: Coordinator {
    
    // MARK: - Properties
    let navigationController: UINavigationController
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public Functions
    override func start() {
        startMusicScene()
    }
    
    // MARK: - Private Functions
    private func startMusicScene() {
        let viewModel = MusicViewModel()
//        viewModel.delegate = self
        let viewController = MusicViewController.create(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
