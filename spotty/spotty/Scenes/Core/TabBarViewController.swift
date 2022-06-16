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
        
        let musicVC = MusicViewController()
        let showsVC = ShowsViewController()
        let playlistVC = PlaylistViewController()
        
        musicVC.title = "Music"
        showsVC.title = "Podcasts"
        playlistVC.title = "Playlists"
        
        musicVC.navigationItem.largeTitleDisplayMode = .always
        showsVC.navigationItem.largeTitleDisplayMode = .always
        playlistVC.navigationItem.largeTitleDisplayMode = .always
        
        let musicNavigation = UINavigationController(rootViewController: musicVC)
        let showsNavigation = UINavigationController(rootViewController: showsVC)
        let playlistNavigation = UINavigationController(rootViewController: playlistVC)
        
        musicNavigation.tabBarItem = UITabBarItem(
            title: "Music",
            image: UIImage(systemName: "music.note"),
            tag: 1)
        showsNavigation.tabBarItem = UITabBarItem(
            title: "Podcasts",
            image: UIImage(systemName: "headphones"),
            tag: 1)
        playlistNavigation.tabBarItem = UITabBarItem(
            title: "Playlists",
            image: UIImage(systemName: "music.note.list"),
            tag: 1)
        
        musicNavigation.navigationBar.prefersLargeTitles = true
        showsNavigation.navigationBar.prefersLargeTitles = true
        playlistNavigation.navigationBar.prefersLargeTitles = true
        
        setViewControllers([musicNavigation, showsNavigation, playlistNavigation], animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let repo = WebRepository()
        repo.getRecentlyPlayedTracks { result in
            switch result {
            case .success(let response):
                dump(response)
            case .failure(let error):
                dump("PROBLEM!!!!!!!!!! \(error)")
            }
        }
    }
}
