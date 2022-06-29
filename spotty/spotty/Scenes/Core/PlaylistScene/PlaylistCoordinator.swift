//
//  PlaylistCoordinator.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 29.06.22.
//

import SFBaseKit

class PlaylistCoordinator: Coordinator {
    
    // MARK: - Properties
    let navigationController: UINavigationController
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public Functions
    override func start() {
        startPlaylistScene()
    }
    
    // MARK: - Private Functions
    private func startPlaylistScene() {
        let viewModel = PlaylistViewModel()
//        viewModel.delegate = self
        let viewController = PlaylistViewController.create(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
