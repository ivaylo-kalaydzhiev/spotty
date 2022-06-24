//
//  PlaylistViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit

class PlaylistViewController: UIViewController { // TODO: Refactor with TableView, this is crazy.
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    
    private var viewModel: PlaylistViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func setupUI() {
        createCollectionView()
        registerNibs()
        createDataSource()
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
        collectionView.register(PlaylistCell.self, forCellWithReuseIdentifier: PlaylistCell.reuseIdentifier)
    }
    
    private func createDataSource() {
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
    
    private func bind() {
        viewModel.playlists.bindAndFire { [weak self] _ in self?.reloadData() }
    }
    
    private func reloadData() {
        guard let playlists = viewModel.playlists.value else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections(Section.allCases)
        
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

fileprivate enum Section: Int, CaseIterable {
    
    case playlists
    
    var collectionLayout: NSCollectionLayoutSection {
        return NSCollectionLayoutSection.createPlaylistLayout()
    }
    
    var cellTypeReuseIdentifier: String {
        return PlaylistCell.reuseIdentifier
    }
}
