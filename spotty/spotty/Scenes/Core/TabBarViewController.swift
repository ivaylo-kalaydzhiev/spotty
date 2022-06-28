//
//  TabBarViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
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
        
        setViewControllers([musicNavigation, showsNavigation, playlistNavigation], animated: false)
    }
}
