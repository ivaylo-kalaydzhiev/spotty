//
//  DetailListViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 22.06.22.
//

import UIKit

class DetailListViewController: UIViewController {
    
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var collectionView: UICollectionView!
    private var dismissButton: UIButton!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    private let sections = [Section.items]
    
    private var viewModel: some DetailListViewModelProtocol = ArtistDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bind()
    }
    
    override var prefersStatusBarHidden: Bool { true }
    
    private func setupUI() {
        createImageView()
        createLabel()
        createCollectionView()
        registerNibs()
        createDataSource()
    }
    
    private func createImageView() {
        guard let image = viewModel.imageSource.value else { return }
        imageView = UIImageView(image: image)
        view.addSubview(imageView, anchors: [.top(0), .leading(0), .trailing(0), .height(view.bounds.width)])
        createDismissButton()
    }
    
    private func createDismissButton() {
        let button = UIButton()
        button.tintColor = .init(white: 1, alpha: 0.7)
        button.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        view.addSubview(button, anchors: [.top(20), .trailing(-20), .height(35), .width(35)])
    }
    
    private func createLabel() {
        guard let title = viewModel.title.value else { return }
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.setCustomStyle(.detailViewTitle)
        view.addSubview(titleLabel, anchors: [.top(view.bounds.width + 10), .leading(20)])
    }
    
    private func createCollectionView() { // TODO: Extract as Factory component maybe.
        collectionView = UICollectionView(frame: CGRect(x: 0,
                                                        y: view.bounds.width + 60,
                                                        width: view.bounds.width,
                                                        height: view.bounds.height),
                                          collectionViewLayout: createCompositionalLayout())
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
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
        viewModel.imageSource.bindAndFire { [weak self] image in
            if let image = image { self?.imageView.image = image }
        }
        viewModel.title.bindAndFire { [weak self] title in
            if let title = title { self?.titleLabel.text = title }
        }
        viewModel.items.bindAndFire { [weak self] items in
            if let items = items { self?.reloadData(items: items) }
        }
    }
    
    private func reloadData(items: [AnyHashable]) { // TODO: Try with BusinessModel
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        snapshot.appendSections(sections)
        snapshot.appendItems(items, toSection: .items)
        
        dataSource?.apply(snapshot)
    }
}

fileprivate enum Section: Int, CaseIterable {
    
    case items
    
    var collectionLayout: NSCollectionLayoutSection {
        switch self {
        case .items:
            return NSCollectionLayoutSection.createDetailViewItemsLayout()
        }
    }
    
    var cellTypeReuseIdentifier: String {
        return ItemCell.reuseIdentifier
    }
}
