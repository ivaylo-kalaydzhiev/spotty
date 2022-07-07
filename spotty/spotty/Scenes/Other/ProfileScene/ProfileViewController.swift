//
//  ProfileViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 30.06.22.
//

import UIKit

fileprivate typealias CollectionViewDataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>

class ProfileViewController: UIViewController {
    
    private var imageView: UIImageView!
    private var dismissButton: UIButton!
    private var collectionView: UICollectionView!
    private var dataSource: CollectionViewDataSource?
    
    private var viewModel: ProfileViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.start()
        setupUI()
        bind()
        
        collectionView.delegate = self
    }
    
    override var prefersStatusBarHidden: Bool { true }
    
    private func setupUI() {
        createImageView()
        createCollectionView()
        registerNibs()
        createDataSource()
        createSectionHeader()
    }
    
    private func createImageView() {
        imageView = UIImageView()
        view.addSubview(imageView, anchors: [.top(0), .leading(0), .trailing(0), .height(view.bounds.width)])
        createDismissButton()
    }
    
    private func createDismissButton() {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.setCustomStyle(.dismiss)
        view.addSubview(button, anchors: [.top(20), .trailing(-20), .height(35), .width(35)])
    }
    
    @objc private func didTapButton() {
        viewModel.dismissView()
    }
    
    private func createCollectionView() {
        collectionView = UICollectionView(
            frame: CGRect(
                x: 0,
                y: view.bounds.width,
                width: view.bounds.width,
                height: view.bounds.height),
            collectionViewLayout: createCompositionalLayout())
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
        viewModel.profileImageURL.bindAndFire { [weak self] imageURL in
            if let imageURL = imageURL { self?.imageView.loadFrom(URLAddress: imageURL) }
        }
        viewModel.tracks.bindAndFire { [weak self] _ in self?.reloadData() }
        viewModel.artists.bindAndFire { [weak self] _ in self?.reloadData() }
    }
    
    private func reloadData() {
        guard let tracks = viewModel.tracks.value,
              let artists = viewModel.artists.value
        else { return }
        
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems(tracks, toSection: .tracks)
        snapshot.appendItems(artists, toSection: .artists)
        
        dataSource?.apply(snapshot)
    }
}

extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section.init(rawValue: indexPath.section) {
        case .tracks:
            viewModel.didSelectAudioTrack(at: indexPath.item)
        case .artists:
            viewModel.didSelectArtist(at: indexPath.item)
        default:
            fatalError()
        }
    }
}

extension ProfileViewController {
    
    static func create(viewModel: ProfileViewModelProtocol) -> UIViewController {
        let viewController = ProfileViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}

fileprivate enum Section: Int, CaseIterable {
    
    case tracks
    case artists
    
    var collectionLayout: NSCollectionLayoutSection {
        switch self {
        case .tracks:
            return .horizontalGroupsOfThreeLayout
        case .artists:
            return .horizontalCirclesLayout
        }
    }
    
    var title: String {
        switch self {
        case .tracks:
            return "Top Tracks"
        case .artists:
            return "Top Artists"
        }
    }
    
    var cellTypeReuseIdentifier: String {
        switch self {
        case .tracks:
            return CollectionMediumCell.reuseIdentifier
        case .artists:
            return CollectionCircularCell.reuseIdentifier
        }
    }
    
    var headerReuseIdentifier: String {
        return SectionHeader.identifier
    }
}

// TODO: Loading indicator/ Placeholder image
// TODO: Search bar
// TODO: Dark/ Light Mode
