//
//  DetailListViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 22.06.22.
//

import UIKit

fileprivate typealias TableViewDataSource = UITableViewDiffableDataSource<Section, AnyHashable>
fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>

// TODO: Table View does not scroll to bottom
class DetailListViewController: UIViewController {
    
    private var imageView: UIImageView!
    private var dismissButton: UIButton!
    private var titleLabel: UILabel!
    
    private var tableView: UITableView!
    private var dataSource: TableViewDataSource?
    
    private var viewModel: DetailListViewModelProtocol!
    
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
        createTableView()
        registerNibs()
        createDataSource()
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
    
    private func createLabel() {
        titleLabel = UILabel()
        titleLabel.setCustomStyle(.detailViewTitle)
        view.addSubview(titleLabel, anchors: [.top(view.bounds.width + 10), .leading(20)])
    }
    
    private func createTableView() {
        tableView = UITableView(frame: CGRect(
            x: 0,
            y: view.bounds.width + 60,
            width: view.bounds.width,
            height: view.bounds.height))
        
        view.addSubview(tableView)
    }
    
    private func registerNibs() {
        tableView.register(TableMediumCell.self)
    }
    
    private func createDataSource() {
        dataSource = TableViewDataSource(tableView: tableView) {
            tableView, indexPath, item in
            
            guard let section = Section.init(rawValue: indexPath.section),
                  let cell = tableView.configuredReuseableCell(
                    section.cellTypeReuseIdentifier,
                    item: item,
                    indexPath: indexPath) as? UITableViewCell
            else { fatalError("Failed to create Reuseable Cell") }
            
            return cell
        }
    }
    
    private func bind() {
        viewModel.imageURL.bindAndFire { [weak self] imageURL in
            if let imageURL = imageURL { self?.imageView.loadFrom(URLAddress: imageURL) }
        }
        viewModel.title.bindAndFire { [weak self] title in
            if let title = title { self?.titleLabel.text = title }
        }
        viewModel.items.bindAndFire { [weak self] _ in self?.reloadData() }
    }
    
    private func reloadData() {
        guard let items = viewModel.items.value,
              let models = items as? [AnyHashable]
        else { return }
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(models, toSection: .items)
        dataSource?.apply(snapshot)
    }
}

extension DetailListViewController {
    
    static func create(viewModel: DetailListViewModelProtocol) -> UIViewController {
        let viewController = DetailListViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}

fileprivate enum Section: Int, CaseIterable {
    
    case items
    
    var cellTypeReuseIdentifier: String {
        return TableMediumCell.reuseIdentifier
    }
}
