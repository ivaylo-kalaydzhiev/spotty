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
        musicViewModel.delegate = self
        
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
        let viewModel: DetailListViewModelProtocol
        if let playlist = model as? Playlist { viewModel = PlaylistDetailViewModel(of: playlist) }
        else if let show = model as? Show { viewModel = ShowDetailViewModel(of: show) }
        else if let artist = model as? Artist { viewModel = ArtistDetailViewModel(of: artist) }
        else { fatalError() }
        
        // viewModel.delegate = self
        let viewController = DetailListViewController.create(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func displayDetailItem(with model: BusinessModel) {
        let viewModel: DetailItemViewModelProtocol
        if let audioTrack = model as? AudioTrack { viewModel = AudioTrackDetailViewModel(of: audioTrack) }
        else if let episode = model as? Episode { viewModel = EpisodeDetailViewModel(of: episode) }
        else { fatalError() }
        
//        viewModel.delegate = self
        let viewController = DetailItemViewController.create(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension CoreCoordinator: CoreViewModelCoordinatorDelegate {
    
    func displayDetailListView(with model: BusinessModel) {
        displayDetailList(with: model)
    }
    
    func displayDetailItemView(with model: BusinessModel) {
        displayDetailItem(with: model)
    }
}
