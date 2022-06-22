//
//  ShowsViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit

class ShowsViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    private let sections = [Section.savedShows, .savedEpisodes]
    
    private var viewModel: ShowsViewModelProtocol! = ShowsViewModel() // TODO: What create function?
    
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
        collectionView.backgroundColor = UIColor.AppColor.background
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
        case .savedShows:
            return collectionView.configureReuseableCell(
                LargeCell.self,
                modelType: Show.self,
                item: item,
                indexPath: indexPath)
        case .savedEpisodes:
            return collectionView.configureReuseableCell(
                MediumCell.self,
                modelType: Episode.self,
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
        viewModel.savedShows.bindAndFire { [weak self] shows in
            guard let shows = shows,
                  let episodes = self?.viewModel.savedEpisodes.value
            else { return }
            self?.reloadData(shows: shows, episodes: episodes)
        }
        viewModel.savedEpisodes.bindAndFire { [weak self] episodes in
            guard  let episodes = episodes,
                   let shows = self?.viewModel.savedShows.value
            else { return }
            self?.reloadData(shows: shows, episodes: episodes)
        }
    }
    
    private func reloadData(shows: [Show], episodes: [Episode]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        snapshot.appendSections(sections)
        snapshot.appendItems(shows, toSection: .savedShows)
        snapshot.appendItems(episodes, toSection: .savedEpisodes)
        
        dataSource?.apply(snapshot)
    }
}

fileprivate enum Section {
    
    case savedShows
    case savedEpisodes
    
    var collectionLayout: NSCollectionLayoutSection {
        switch self {
        case .savedShows:
            return NSCollectionLayoutSection.createFeaturedSectionLayout()
        case .savedEpisodes:
            return NSCollectionLayoutSection.createVerticalLayout()
        }
    }
    
    var title: String {
        switch self {
        case .savedShows:
            return "Your Shows"
        case .savedEpisodes:
            return "Saved Episodes"
        }
    }
}
