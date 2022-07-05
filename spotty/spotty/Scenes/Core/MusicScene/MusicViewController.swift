//
//  MusicViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit
import SFBaseKit

// TODO: Fix Section and SectionItem types
fileprivate typealias CollectionViewDataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>

class MusicViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: CollectionViewDataSource?
    
    private var viewModel: MusicViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        
        navigationItem.largeTitleDisplayMode = .always
        collectionView.delegate = self
    }
    
    private func setupUI() {
        title = viewModel.screenTitle
        createProfileButton()
        createCollectionView()
        registerNibs()
        createDataSource()
        createSectionHeader()
    }
    
    private func createProfileButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.crop.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapProfileButton))
    }
    
    @objc private func didTapProfileButton() {
         viewModel.didTapProfileButton()
    }
    
    private func createCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
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
        collectionView.register(CollectionCircularCell.self)
        collectionView.register(SectionHeader.self)
    }
    
    private func createDataSource() {
        dataSource = CollectionViewDataSource(collectionView: collectionView) { collectionView, indexPath, item in
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
        viewModel.featuredPlaylists.bindAndFire { [weak self] _ in self?.reloadData() }
        viewModel.recentlyPlayedTracks.bindAndFire { [weak self] _ in self?.reloadData() }
        viewModel.recentlyPlayedArtists.bindAndFire { [weak self] _ in self?.reloadData() }
    }
    
    private func reloadData() {
        guard let playlists = viewModel.featuredPlaylists.value,
              let tracks = viewModel.recentlyPlayedTracks.value,
              let artists = viewModel.recentlyPlayedArtists.value
        else { return }
        
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems(playlists, toSection: .featuredPlaylists)
        snapshot.appendItems(tracks, toSection: .recentlyPlayedTracks)
        snapshot.appendItems(artists, toSection: .recentlyPlayedArtists)
        
        dataSource?.apply(snapshot)
    }
}

extension MusicViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section.init(rawValue: indexPath.section) {
        case .featuredPlaylists:
            viewModel.didSelectPlaylist(at: indexPath.item)
        case .recentlyPlayedTracks:
            viewModel.didSelectAudioTrack(at: indexPath.item)
        case .recentlyPlayedArtists:
            viewModel.didSelectArtist(at: indexPath.item)
        default:
            fatalError()
        }
    }
}

extension MusicViewController {
    
    static func create(viewModel: MusicViewModelProtocol) -> UIViewController {
        let viewController = MusicViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}

fileprivate enum Section: Int, CaseIterable {
    
    case featuredPlaylists
    case recentlyPlayedTracks
    case recentlyPlayedArtists
    
    var collectionLayout: NSCollectionLayoutSection {
        switch self {
        case .featuredPlaylists:
            return .featuredSectionLayout
        case .recentlyPlayedTracks:
            return .horizontalGroupsOfThreeLayout
        case .recentlyPlayedArtists:
            return .horizontalCirclesLayout
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
    
    var cellTypeReuseIdentifier: String {
        switch self {
        case .featuredPlaylists:
            return CollectionLargeCell.reuseIdentifier
        case .recentlyPlayedTracks:
            return CollectionMediumCell.reuseIdentifier
        case .recentlyPlayedArtists:
            return CollectionCircularCell.reuseIdentifier
        }
    }
    
    var headerReuseIdentifier: String {
        return SectionHeader.identifier
    }
}
