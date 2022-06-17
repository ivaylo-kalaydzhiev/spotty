//
//  MusicViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit

class MusicViewController: UIViewController {
    
    // ViewModel
    private var viewModel = MusicViewModel()
    
    // Data Source
    private var dataSource: UICollectionViewDiffableDataSource<AudioTrackSection, AudioTrack>?

    // UI Elements
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        bind()
        viewModel.loadSections()
        createCollectionView()
        registerNibs()
        createDataSource()
    }
    
    private func bind() {
        viewModel.sections.bind { [weak self] _ in self?.reloadData() }
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
            switch self.viewModel.sections.value?[indexPath.section].type {
            default:
                return self.configure(MediumCell.self, with: track, for: indexPath)
            }
        }
    }
    
    private func reloadData() {
        guard let sections = viewModel.sections.value else { fatalError("Oops. ") }
        var snapshot = NSDiffableDataSourceSnapshot<AudioTrackSection, AudioTrack>()
        snapshot.appendSections(sections)
        
        for section in sections {
            snapshot.appendItems(section.items!, toSection: section)
        }
        
        dataSource?.apply(snapshot)
    }
    
    // MARK: - Layout
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            guard let section = self.viewModel.sections.value?[sectionIndex] else { fatalError("Oops. ") }
            
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
