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
    
    private let viewModel = MusicViewModel()
    
    enum Section: String, CaseIterable, Hashable {
        
        case featuredPlaylists
        case recentlyPlayedTracks
        case recentlyPlayedArtists
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCollectionView()
        registerNibs()
        createDataSource()
        bind()
    }
    
    private func bind() {
        viewModel.featuredPlaylists.bind { [weak self] playlists in
            if let playlists = playlists,
               let artists = self?.viewModel.recentlyPlayedArtists.value,
               let tracks = self?.viewModel.recentlyPlayedTracks.value  {
                self?.reloadData(playlists: playlists, tracks: tracks, artists: artists)
            }
        }
        viewModel.recentlyPlayedTracks.bind { [weak self] tracks in
            if let tracks = tracks,
               let artists = self?.viewModel.recentlyPlayedArtists.value,
               let playlists = self?.viewModel.featuredPlaylists.value  {
                self?.reloadData(playlists: playlists, tracks: tracks, artists: artists)
            }
        }
        viewModel.recentlyPlayedArtists.bind { [weak self] artists in
            if let artists = artists,
               let playlists = self?.viewModel.featuredPlaylists.value,
               let tracks = self?.viewModel.recentlyPlayedTracks.value{
                self?.reloadData(playlists: playlists, tracks: tracks, artists: artists)
            }
        }
    }
    
    private func createCollectionView() {
        let compositionalLayout = createCompositionalLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: compositionalLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func registerNibs() {
        collectionView.register(LargeCell.self, forCellWithReuseIdentifier: LargeCell.reuseIdentifier)
        collectionView.register(MediumCell.self, forCellWithReuseIdentifier: MediumCell.reuseIdentifier)
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.reuseIdentifier)
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) {
            collectionView, indexPath, item in
            
            if let playlist = item as? Playlist,
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeCell.reuseIdentifier, for: indexPath) as? LargeCell {
                
                cell.imageView.loadFrom(URLAddress: playlist.images[0].url)
                return cell
            } else if let track = item as? AudioTrack,
                      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediumCell.reuseIdentifier, for: indexPath) as? MediumCell {
                
                cell.title.text = track.name
                cell.subtitle.text = track.artists.map { $0.name }.joined(separator: ", ")
                cell.imageView.loadFrom(URLAddress: track.album.images[2].url)
                return cell
            } else if let artist = item as? Artist,
                      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediumCell.reuseIdentifier, for: indexPath) as? MediumCell {
                cell.title.text = artist.name
                cell.subtitle.text = artist.genres?.joined(separator: ", ")
                cell.imageView.image = UIImage.init(systemName: "gear")
                return cell
            } else {
                fatalError("Unknown cell type")
            }
        }
        
        // Giving Data to the Header
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeader.reuseIdentifier,
                for: indexPath) as? SectionHeader
            else { return nil }
            
            let sections: [Section] = [.featuredPlaylists, .recentlyPlayedTracks, .recentlyPlayedArtists]
            let section = sections[indexPath.section]
            
            switch section {
            case .featuredPlaylists:
                sectionHeader.title.text = "Spotify Playlists"
            case .recentlyPlayedTracks:
                sectionHeader.title.text = "Recently played"
            case .recentlyPlayedArtists:
                sectionHeader.title.text = "Recent Artists"
            }
            return sectionHeader
        }
    }
    
    private func reloadData(playlists: [Playlist], tracks: [AudioTrack], artists: [Artist]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        snapshot.appendSections([.featuredPlaylists, .recentlyPlayedTracks, .recentlyPlayedArtists])
        snapshot.appendItems(playlists, toSection: .featuredPlaylists)
        snapshot.appendItems(tracks, toSection: .recentlyPlayedTracks)
        snapshot.appendItems(artists, toSection: .recentlyPlayedArtists)
        
        dataSource?.apply(snapshot)
    }
}


// MARK: - Compositional Layout
extension MusicViewController {
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            let sections: [Section] = [.featuredPlaylists, .recentlyPlayedTracks, .recentlyPlayedArtists]
            let section = sections[sectionIndex]
            
            switch section {
            case .featuredPlaylists:
                return self.createLargeSection()
            case .recentlyPlayedTracks, .recentlyPlayedArtists:
                return self.createMediumSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createLargeSection() -> NSCollectionLayoutSection {
        // Size, Item, Group, Section
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93),
                                               heightDimension: .fractionalWidth(0.93))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])
        
        // Section
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        // Header
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    private func createMediumSection() -> NSCollectionLayoutSection {
        // Size, Item, Group, Section
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(0.33))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93),
                                               heightDimension: .fractionalWidth(0.55))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [layoutItem])
        
        // Section
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        // Header
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.93),
            heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        return layoutSectionHeader
    }
}
