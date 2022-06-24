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
    
    private var viewModel: ShowsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            return Section.init(rawValue: sectionIndex)?.collectionLayout
        }
        
        return layout.configured()
    }
    
    private func registerNibs() {
        collectionView.register(MediumCell.self,
                                forCellWithReuseIdentifier: MediumCell.reuseIdentifier)
        collectionView.register(LargeCell.self,
                                forCellWithReuseIdentifier: LargeCell.reuseIdentifier)
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.reuseIdentifier)
    }
    
    private func createDataSource() { // TODO: A lot of methods are the same, might inherit
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) {
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
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems(shows, toSection: .savedShows)
        snapshot.appendItems(episodes, toSection: .savedEpisodes)
        
        dataSource?.apply(snapshot)
    }
}

extension ShowsViewController {
    
    static func create(viewModel: ShowsViewModelProtocol = ShowsViewModel()) -> UIViewController {
        let viewController = ShowsViewController()
        viewController.title = Constant.SceneTitle.show
        viewController.navigationItem.largeTitleDisplayMode = .always
        viewController.viewModel = viewModel
        return viewController
    }
}

fileprivate enum Section: Int, CaseIterable {
    
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
    
    var cellTypeReuseIdentifier: String {
        switch self {
        case .savedShows:
            return LargeCell.reuseIdentifier
        case .savedEpisodes:
            return MediumCell.reuseIdentifier
        }
    }
    
    var headerReuseIdentifier: String {
        return SectionHeader.reuseIdentifier
    }
}
