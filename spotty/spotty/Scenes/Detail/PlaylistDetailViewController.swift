//
//  PlaylistDetailViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 22.06.22.
//

import UIKit

class PlaylistDetailViewController: UIViewController {

    private var collectionView: UICollectionView!
    private var playlistCoverImageView: UIImageView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    private let sections = [Section.items]
    
    private var viewModel: PlaylistDetailViewModelProtocol! = PlaylistDetailViewModel() // TODO: What create function?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupUI() {
        createImageView()
        createCollectionView()
        registerNibs()
        createDataSource()
    }
    
    private func createImageView() {
        guard let playlist = viewModel.playlist.value else { return }
        playlistCoverImageView = UIImageView()
        playlistCoverImageView.loadFrom(URLAddress: playlist.images[0].url)
        view.addSubview(playlistCoverImageView, anchors: [.top(0), .leading(0), .trailing(0), .height(view.bounds.width)]) // might explode
    }
    
    private func createCollectionView() { // TODO: Extract as Factory component maybe.
        collectionView = UICollectionView(frame: CGRect(x: 0,
                                                        y: view.bounds.width,
                                                        width: view.bounds.width,
                                                        height: view.bounds.height),
                                          collectionViewLayout: createCompositionalLayout())
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor.AppColor.background
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section = self.sections[sectionIndex]
            return section.collectionLayout
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func registerNibs() {
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
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
    }
    
    private func makeConfiguredCell(for section: Section,
                                    collectionView: UICollectionView,
                                    item: AnyHashable,
                                    indexPath: IndexPath) -> UICollectionViewCell {
        switch section {
        case .items:
            return collectionView.configureReuseableCell(
                ItemCell.self,
                modelType: AudioTrack.self,
                item: item,
                indexPath: indexPath)
        }
    }
    
    private func bind() {
        viewModel.tracks.bindAndFire { [weak self] tracks in
            if let tracks = tracks { self?.reloadData(tracks: tracks) }
        }
        viewModel.playlist.bindAndFire { [weak self] playlist in
            if let playlist = playlist { self?.playlistCoverImageView.loadFrom(URLAddress: playlist.images[0].url) }
        }
    }
    
    private func reloadData(tracks: [AudioTrack]) { // TODO: Try with BusinessModel
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        snapshot.appendSections(sections)
        snapshot.appendItems(tracks, toSection: .items)
        
        dataSource?.apply(snapshot)
    }
}

fileprivate enum Section {
    
    case items
    
    var collectionLayout: NSCollectionLayoutSection {
        switch self {
        case .items:
            return NSCollectionLayoutSection.createDetailViewItemsLayout()
        }
    }
}
