//
//  PlaylistViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit

fileprivate typealias TableViewDataSource = UITableViewDiffableDataSource<Section, AnyHashable>
fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>

class PlaylistViewController: UIViewController {
    
    private var tableView: UITableView!
    private var dataSource: TableViewDataSource?
    
    private var viewModel: PlaylistViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start()
        setupUI()
        bind()
        
        navigationItem.largeTitleDisplayMode = .always
        tableView.delegate = self
    }
    
    private func setupUI() {
        title = viewModel.screenTitle
        createProfileButton()
        createTableView()
        registerNibs()
        createDataSource()
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
    
    private func createTableView() {
        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
    }
    
    private func registerNibs() {
        tableView.register(TableLargeCell.self)
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
        viewModel.playlists.bindAndFire { [weak self] _ in self?.reloadData() }
    }
    
    private func reloadData() {
        guard let playlists = viewModel.playlists.value else { return }
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(playlists, toSection: .playlists)
        dataSource?.apply(snapshot)
    }
}

extension PlaylistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectPlaylist(at: indexPath.item)
    }
}

extension PlaylistViewController {
    
    static func create(viewModel: PlaylistViewModelProtocol) -> UIViewController {
        let viewController = PlaylistViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}

fileprivate enum Section: Int, CaseIterable {
    
    case playlists
    
    var cellTypeReuseIdentifier: String {
        return TableLargeCell.reuseIdentifier
    }
}
