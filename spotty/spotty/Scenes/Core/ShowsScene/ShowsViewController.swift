//
//  ShowsViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit

fileprivate typealias CollectionViewDataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>

class ShowsViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: CollectionViewDataSource?
    
    private var viewModel: ShowsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        setupUI()
        bind()
    }
    
    private func setupUI() {
        createCollectionView()
        registerNibs()
        createDataSource()
        createSectionHeader()
    }
    
    private func createCollectionView() {
        let compositionalLayout = createCompositionalLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: compositionalLayout)
        collectionView.setCustomStyle(style: .main)
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return Section.init(rawValue: sectionIndex)?.collectionLayout
        }
        
        return layout.configured()
    }
    
    private func registerNibs() {
        collectionView.register(CollectionMediumCell.self)
        collectionView.register(CollectionLargeCell.self)
        collectionView.register(SectionHeader.self)
    }
    
    private func createDataSource() {
        dataSource = CollectionViewDataSource(collectionView: collectionView) {
            collectionView, indexPath, item in
            
            guard let section = Section.init(rawValue: indexPath.section),
                  let cell = collectionView.configuredReuseableCell(
                    section.cellTypeReuseIdentifier,
                    item: item,
                    indexPath: indexPath) as? UICollectionViewCell
            else { fatalError("Failed to create Reuseable Cell") }
            
            return cell
        }
    }
    
    private func createSectionHeader() {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let section = Section.init(rawValue: indexPath.section),
                  let sectionHeader = collectionView.configuredSupplimentaryView(
                    section.headerReuseIdentifier,
                    title: section.title,
                    kind: kind,
                    indexPath: indexPath) as? UICollectionReusableView
            else { fatalError("Failed to create Header") }
            
            return sectionHeader
        }
    }
    
    private func bind() {
        viewModel.savedShows.bindAndFire { [weak self] _ in self?.reloadData() }
        viewModel.savedEpisodes.bindAndFire { [weak self] _ in self?.reloadData() }
    }
    
    private func reloadData() {
        guard let shows = viewModel.savedShows.value,
              let episodes = viewModel.savedEpisodes.value
        else { return }
        
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems(shows, toSection: .savedShows)
        snapshot.appendItems(episodes, toSection: .savedEpisodes)
        
        dataSource?.apply(snapshot)
    }
}

extension ShowsViewController {
    
    static func create(viewModel: ShowsViewModelProtocol = ShowsViewModel()) -> UIViewController {
        let viewController = ShowsViewController()
        viewController.viewModel = viewModel
        viewController.title = viewModel.title
        return viewController
    }
}

fileprivate enum Section: Int, CaseIterable {
    
    case savedShows
    case savedEpisodes
    
    var collectionLayout: NSCollectionLayoutSection {
        switch self {
        case .savedShows:
            return NSCollectionLayoutSection.featuredSectionLayout
        case .savedEpisodes:
            return NSCollectionLayoutSection.verticalLayout
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
    
    var cellTypeReuseIdentifier: String {
        switch self {
        case .savedShows:
            return CollectionLargeCell.reuseIdentifier
        case .savedEpisodes:
            return CollectionMediumCell.reuseIdentifier
        }
    }
    
    var headerReuseIdentifier: String {
        return SectionHeader.identifier
    }
}
