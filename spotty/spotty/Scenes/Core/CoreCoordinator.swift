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
        let musicViewModel = MusicViewModel()
        musicViewModel.delegate = self
        let showsViewModel = ShowsViewModel()
        showsViewModel.delegate = self
        let playlistViewModel = PlaylistViewModel()
        playlistViewModel.delegate = self
        
        let musicNavigation = UINavigationController.createReadyForTabBar(
            viewController: MusicViewController.create(viewModel: musicViewModel),
            title: Constant.SceneTitle.music,
            image: UIImage.System.musicNote)
        let showsNavigation = UINavigationController.createReadyForTabBar(
            viewController: ShowsViewController.create(viewModel: showsViewModel),
            title: Constant.SceneTitle.show,
            image: UIImage.System.headphones)
        let playlistNavigation = UINavigationController.createReadyForTabBar(
            viewController: PlaylistViewController.create(viewModel: playlistViewModel),
            title: Constant.SceneTitle.playlist,
            image: UIImage.System.musicNoteList)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            musicNavigation,
            showsNavigation,
            playlistNavigation
        ]
        
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    private func displayDetailList(with model: BusinessModel) {
        let viewController: UIViewController
        if let playlist = model as? Playlist {
            let viewModel = PlaylistDetailViewModel(of: playlist)
            viewModel.delegate = self
            viewController = DetailListViewController.create(viewModel: viewModel)
        } else if let show = model as? Show {
            let viewModel = ShowDetailViewModel(of: show)
            viewModel.delegate = self
            viewController = DetailListViewController.create(viewModel: viewModel)
        } else if let artist = model as? Artist {
            let viewModel = ArtistDetailViewModel(of: artist)
            viewModel.delegate = self
            viewController = DetailListViewController.create(viewModel: viewModel)
        } else {
            fatalError()
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func displayDetailItem(with model: BusinessModel) {
        let viewController: UIViewController
        if let audioTrack = model as? AudioTrack {
            let viewModel = AudioTrackDetailViewModel(of: audioTrack)
            viewModel.delegate = self
            viewController = DetailItemViewController.create(viewModel: viewModel)
        } else if let episode = model as? Episode {
            let viewModel = EpisodeDetailViewModel(of: episode)
            viewModel.delegate = self
            viewController = DetailItemViewController.create(viewModel: viewModel)
        } else {
            fatalError()
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func dismissDetail() {
        navigationController.popViewController(animated: true)
    }
}

extension CoreCoordinator: CoreViewModelCoordinatorDelegate {
    
    func displayDetailListView(with model: BusinessModel) {
        displayDetailList(with: model)
    }
    
    func displayDetailItemView(with model: BusinessModel) {
        displayDetailItem(with: model)
    }
    
    func dismissView() {
        dismissDetail()
    }
}
