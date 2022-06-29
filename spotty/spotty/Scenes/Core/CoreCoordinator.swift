//
//  CoreCoordinator.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 29.06.22.
//

import SFBaseKit

class CoreCoordinator: Coordinator {
    
    // MARK: - Properties
    private let navigationController: UINavigationController
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Exposed Functions
    override func start() {
        let tabBarController = UITabBarController()
        
        let musicNavigation = UINavigationController.createReadyForTabBar(
            viewController: MusicViewController.create(),
            title: Constant.SceneTitle.music,
            image: UIImage.System.musicNote)
        let showsNavigation = UINavigationController.createReadyForTabBar(
            viewController: ShowsViewController.create(),
            title: Constant.SceneTitle.show,
            image: UIImage.System.headphones)
        let playlistNavigation = UINavigationController.createReadyForTabBar(
            viewController: PlaylistViewController.create(),
            title: Constant.SceneTitle.playlist,
            image: UIImage.System.musicNoteList)
        
        let musicCoordinator = MusicCoordinator(navigationController: musicNavigation)
        let showsCoordinator = ShowsCoordinator(navigationController: playlistNavigation)
        let playlistCoordinator = PlaylistCoordinator(navigationController: showsNavigation)
        
        tabBarController.viewControllers = [
            musicCoordinator.navigationController,
            showsCoordinator.navigationController,
            playlistCoordinator.navigationController
        ]
        
        addChildCoordinators([musicCoordinator, showsCoordinator, playlistCoordinator])
        
        navigationController.pushViewController(tabBarController, animated: true)
    }
}
