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
        viewModel.delegate = self
        let viewController = MusicViewController.create(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
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

extension MusicCoordinator: MusicViewModelCoordinatorDelegate {
    
    func displayDetailListView(with model: BusinessModel) {
        displayDetailList(with: model)
    }
    
    func displayDetailItemView(with model: BusinessModel) {
        displayDetailItem(with: model)
    }
}
