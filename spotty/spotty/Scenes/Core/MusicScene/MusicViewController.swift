//
//  MusicViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit

class MusicViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    private let sections: [Section] = [.featuredPlaylists, .recentlyPlayedTracks, .recentlyPlayedArtists]
    private let viewModel = MusicViewModel()
    
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
        collectionView.backgroundColor = .systemBackground
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
            
            let section = self.sections[indexPath.section]
            return self.makeConfiguredCell(for: section, collectionView: collectionView, item: item, indexPath: indexPath)
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
                modelType: Playlist.self,
                item: item,
                indexPath: indexPath)
        case .recentlyPlayedTracks:
            return collectionView.configureReuseableCell(
                MediumCell.self,
                modelType: AudioTrack.self,
                item: item,
                indexPath: indexPath)
        case .recentlyPlayedArtists:
            return collectionView.configureReuseableCell(
                MediumCell.self,
                modelType: Artist.self,
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
            if let playlists = playlists,
               let artists = self?.viewModel.recentlyPlayedArtists.value,
               let tracks = self?.viewModel.recentlyPlayedTracks.value {
                self?.reloadData(playlists: playlists, tracks: tracks, artists: artists)
            }
        }
        viewModel.recentlyPlayedTracks.bindAndFire { [weak self] tracks in
            if let tracks = tracks,
               let artists = self?.viewModel.recentlyPlayedArtists.value,
               let playlists = self?.viewModel.featuredPlaylists.value {
                self?.reloadData(playlists: playlists, tracks: tracks, artists: artists)
            }
        }
        viewModel.recentlyPlayedArtists.bindAndFire { [weak self] artists in
            if let artists = artists,
               let playlists = self?.viewModel.featuredPlaylists.value,
               let tracks = self?.viewModel.recentlyPlayedTracks.value {
                self?.reloadData(playlists: playlists, tracks: tracks, artists: artists)
            }
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

fileprivate enum Section {
    
    case featuredPlaylists
    case recentlyPlayedTracks
    case recentlyPlayedArtists
    
    var collectionLayout: NSCollectionLayoutSection {
        switch self {
        case .featuredPlaylists:
            return NSCollectionLayoutSection.createLargeSection()
        case .recentlyPlayedTracks,
                .recentlyPlayedArtists:
            return NSCollectionLayoutSection.createMediumSection()
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
