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
        case recentlyPlayed
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCollectionView()
        registerNibs()
        createDataSource()
        bind()
    }
    
    private func bind() { // Bind and fire?
        viewModel.featuredPlaylists.bind { [weak self] playlists in
            if let playlists = playlists,
               let tracks = self?.viewModel.recentlyPlayedTracks.value  {
                self?.reloadData(playlists: playlists, tracks: tracks)
            }
        }
        viewModel.recentlyPlayedTracks.bind { [weak self] tracks in
            if let tracks = tracks,
               let playlists = self?.viewModel.featuredPlaylists.value  {
                self?.reloadData(playlists: playlists, tracks: tracks)
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
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) {
            collectionView, indexPath, item in
            
            if let playlist = item as? Playlist,
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeCell.reuseIdentifier, for: indexPath) as? LargeCell {
                
                cell.subtitle.text = playlist.description
                cell.imageView.loadFrom(URLAddress: playlist.images[0].url)
                return cell
            } else if let track = item as? AudioTrack,
                      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediumCell.reuseIdentifier, for: indexPath) as? MediumCell {
                
                cell.title.text = track.name
                cell.subtitle.text = track.artists.map { $0.name }.joined(separator: ", ")
                cell.imageView.loadFrom(URLAddress: track.album.images[2].url)
                return cell
            } else {
                fatalError("Unknown cell type")
            }
        }
    }
    
    private func reloadData(playlists: [Playlist], tracks: [AudioTrack]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        snapshot.appendSections([.featuredPlaylists, .recentlyPlayed])
        snapshot.appendItems(playlists, toSection: .featuredPlaylists)
        snapshot.appendItems(tracks, toSection: .recentlyPlayed)
        
        dataSource?.apply(snapshot)
    }
}


// MARK: - Layout
extension MusicViewController {

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            let sections: [Section] = [.featuredPlaylists, .recentlyPlayed]
            let section = sections[sectionIndex]
            
            switch section {
            case .featuredPlaylists:
                return self.createLargeSection()
            case .recentlyPlayed:
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
                                               heightDimension: .estimated(350))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])

        // Section
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered

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

        return layoutSection
    }
}
