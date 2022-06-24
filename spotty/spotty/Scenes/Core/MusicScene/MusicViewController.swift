//
//  MusicViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit
import SFBaseKit

class MusicViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    private let sections = [Section.featuredPlaylists, .recentlyPlayedTracks, .recentlyPlayedArtists]
    
    private var viewModel: MusicViewModelProtocol!
    
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
    
    private func createCollectionView() {
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
        collectionView.register(MediumCell.self, forCellWithReuseIdentifier: MediumCell.reuseIdentifier)
        collectionView.register(LargeCell.self, forCellWithReuseIdentifier: LargeCell.reuseIdentifier)
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.reuseIdentifier)
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) {
            collectionView, indexPath, item in
            
            guard let section = self.sections[safeAt: indexPath.section] else { fatalError("Section out of bounds.") }
            return self.makeConfiguredCell(for: section,
                                           collectionView: collectionView,
                                           item: item,
                                           indexPath: indexPath)
        }
        
        addSectionHeader()
    }
    
    private func makeConfiguredCell(for section: Section,
                                    collectionView: UICollectionView,
                                    item: AnyHashable,
                                    indexPath: IndexPath) -> UICollectionViewCell {
        switch section {
        case .featuredPlaylists:
            return collectionView.configureReuseableCell(
                LargeCell.self,
                item: item,
                indexPath: indexPath)
        case .recentlyPlayedTracks:
            return collectionView.configureReuseableCell(
                MediumCell.self,
                item: item,
                indexPath: indexPath)
        case .recentlyPlayedArtists:
            return collectionView.configureReuseableCell(
                MediumCell.self,
                item: item,
                indexPath: indexPath)
        }
    }
    
    private func addSectionHeader() {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            let sectionHeader = collectionView.configureSupplimentaryView(
                SectionHeader.self,
                kind: kind,
                indexPath: indexPath)
            
            let section = self.sections[indexPath.section]
            sectionHeader.title.text = section.title
            return sectionHeader
        }
    }
    
    private func bind() {
        viewModel.featuredPlaylists.bindAndFire { [weak self] playlists in
            guard let playlists = playlists,
                  let artists = self?.viewModel.recentlyPlayedArtists.value,
                  let tracks = self?.viewModel.recentlyPlayedTracks.value
            else { return }
            self?.reloadData(playlists: playlists, tracks: tracks, artists: artists)
        }
        viewModel.recentlyPlayedTracks.bindAndFire { [weak self] tracks in
            guard let tracks = tracks,
                  let artists = self?.viewModel.recentlyPlayedArtists.value,
                  let playlists = self?.viewModel.featuredPlaylists.value
            else { return }
            self?.reloadData(playlists: playlists, tracks: tracks, artists: artists)
        }
        viewModel.recentlyPlayedArtists.bindAndFire { [weak self] artists in
            guard let artists = artists,
                  let playlists = self?.viewModel.featuredPlaylists.value,
                  let tracks = self?.viewModel.recentlyPlayedTracks.value
            else { return }
            self?.reloadData(playlists: playlists, tracks: tracks, artists: artists)
        }
    }
    
    private func reloadData(playlists: [Playlist], tracks: [AudioTrack], artists: [Artist]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        snapshot.appendSections(sections)
        snapshot.appendItems(playlists, toSection: .featuredPlaylists)
        snapshot.appendItems(tracks, toSection: .recentlyPlayedTracks)
        snapshot.appendItems(artists, toSection: .recentlyPlayedArtists)
        
        dataSource?.apply(snapshot)
    }
}

extension MusicViewController {
    
    static func create(viewModel: MusicViewModelProtocol = MusicViewModel()) -> UIViewController {
        let viewController = MusicViewController()
        viewController.title = Constant.SceneTitle.music
        viewController.navigationItem.largeTitleDisplayMode = .always
        viewController.viewModel = viewModel
        return viewController
    }
}

fileprivate enum Section {
    
    case featuredPlaylists
    case recentlyPlayedTracks
    case recentlyPlayedArtists
    
    var collectionLayout: NSCollectionLayoutSection {
        switch self {
        case .featuredPlaylists:
            return NSCollectionLayoutSection.createFeaturedSectionLayout()
        case .recentlyPlayedTracks,
             .recentlyPlayedArtists:
            return NSCollectionLayoutSection.createHorizontalGroupsOfThreeLayout()
        }
    }
    
    var title: String {
        switch self {
        case .featuredPlaylists:
            return "Spotify Playlists"
        case .recentlyPlayedTracks:
            return "Recently played"
        case .recentlyPlayedArtists:
            return "Recent Artists"
        }
    }
}
