//
//  PlaylistViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit

class PlaylistViewController: UIViewController {

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    private let sections = [Section.playlists]
    
    private var viewModel: PlaylistViewModelProtocol! = PlaylistViewModel() // TODO: What create function?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        bind()
    }
    
    private func setupCollectionView() {
        createCollectionView()
        registerNibs()
        createDataSource()
    }
    
    private func createCollectionView() { // TODO: Extract as Factory component maybe.
        let compositionalLayout = createCompositionalLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: compositionalLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor.background
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            let section = self.sections[sectionIndex]
            return section.collectionLayout
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func registerNibs() {
        collectionView.register(PlaylistCell.self, forCellWithReuseIdentifier: PlaylistCell.reuseIdentifier)
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) {
            collectionView, indexPath, item in
            
            guard let section = self.sections[safeAt: indexPath.section] else { return UICollectionViewCell() }
            
            return self.makeConfiguredCell(for: section,
                                           collectionView: collectionView,
                                           item: item,
                                           indexPath: indexPath)
        }
    }
    
    private func makeConfiguredCell(for section: Section,
                                    collectionView: UICollectionView,
                                    item: AnyHashable,
                                    indexPath: IndexPath) -> UICollectionViewCell {
        switch section {
        case .playlists:
            return collectionView.configuredReuseableCell(
                PlaylistCell.self,
                item: item,
                indexPath: indexPath)
        }
    }
    
    private func bind() {
        viewModel.playlists.bindAndFire { [weak self] playlists in
            if let playlists = playlists { self?.reloadData(playlists: playlists) }
        }
    }
    
    private func reloadData(playlists: [Playlist]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        snapshot.appendSections(sections)
        snapshot.appendItems(playlists, toSection: .playlists)
        
        dataSource?.apply(snapshot)
    }
}

extension PlaylistViewController {
    
    static func create(viewModel: PlaylistViewModelProtocol = PlaylistViewModel()) -> UIViewController {
        let viewController = PlaylistViewController()
        viewController.viewModel = viewModel
        viewController.title = Constant.SceneTitle.playlist
        viewController.navigationItem.largeTitleDisplayMode = .always
        return viewController
    }
}

fileprivate enum Section {
    
    case playlists
    
    var collectionLayout: NSCollectionLayoutSection {
        switch self {
        case .playlists:
            return NSCollectionLayoutSection.createPlaylistLayout()
        }
    }
}
