//
//  MusicViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit

class MusicViewController: UIViewController {
    
    let webRepository = WebRepository()
    
    private var sections = [ // Get them from the ViewModel
        AudioTrackSection(
            id: 1,
            type: "recentlyPlayed",
            title: "Recently Played",
            subtitle: "",
            items: nil)
    ]
    
    private var dataSource: UICollectionViewDiffableDataSource<AudioTrackSection, AudioTrack>?
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        loadData()
        createCollectionView()
        registerNibs()
        createDataSource()
//        reloadData()
    }
    
    private func loadData() {
        webRepository.getRecentlyPlayedTracks { result in
            switch result {
            case .success(let items):
                let wrappedAudioTracks = items.value
                let tracks = wrappedAudioTracks.map { $0.track }
                self.sections[0].items = tracks
                self.reloadData()
            case .failure(let error):
                dump(error.localizedDescription)
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
        collectionView.register(MediumCell.self, forCellWithReuseIdentifier: MediumCell.reuseIdentifier)
    }
    
    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type,
                                                   with track: AudioTrack,
                                                   for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath) as? T
        else { fatalError("You're doing it wrong!") }
        
        cell.configure(with: track)
        return cell
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<AudioTrackSection, AudioTrack>(collectionView: collectionView) {
            collectionView, indexPath, track in
            switch self.sections[indexPath.section].type {
            default:
                return self.configure(MediumCell.self, with: track, for: indexPath)
            }
        }
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<AudioTrackSection, AudioTrack>()
        snapshot.appendSections(sections)
        
            snapshot.appendItems(sections[0].items!, toSection: sections[0])
        
        
        dataSource?.apply(snapshot)
    }
    
    // MARK: - Layout
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            let section = self.sections[sectionIndex]
            
            switch section.type {
            default:
                return self.createMediumTableSection(using: section)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createMediumTableSection(using section: AudioTrackSection) -> NSCollectionLayoutSection {
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

// Protocol only for Music Items
struct AudioTrackSection: Hashable {
    
    let id: Int
    let type: String
    let title: String
    let subtitle: String
    var items: [AudioTrack]?
}
