//
//  SearchViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 7.07.22.
//

import UIKit

fileprivate typealias TableViewDataSource = UITableViewDiffableDataSource<Section, AnyHashable>
fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>

class SearchViewController: UIViewController {
    
    private var tableView: UITableView!
    private var dataSource: TableViewDataSource?
    
    private var viewModel: SearchViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start()
        setupUI()
        bind()
        
        tableView.delegate = self
    }
    
    private func setupUI() {
        createTableView()
        registerNibs()
        createDataSource()
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
        viewModel.tracks.bindAndFire { [weak self] _ in self?.reloadData() }
        viewModel.artists.bindAndFire { [weak self] _ in self?.reloadData() }
        viewModel.playlists.bindAndFire { [weak self] _ in self?.reloadData() }
        viewModel.episodes.bindAndFire { [weak self] _ in self?.reloadData() }
        viewModel.shows.bindAndFire { [weak self] _ in self?.reloadData() }
    }
    
    private func reloadData() {
        guard let tracks = viewModel.tracks.value,
              let artists = viewModel.artists.value,
              let playlists = viewModel.playlists.value,
              let episodes = viewModel.episodes.value,
              let shows = viewModel.shows.value
        else { return }
        
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(tracks, toSection: .tracks)
        snapshot.appendItems(artists, toSection: .artists)
        snapshot.appendItems(playlists, toSection: .playlists)
        snapshot.appendItems(episodes, toSection: .episodes)
        snapshot.appendItems(shows, toSection: .shows)
        
        dataSource?.apply(snapshot)
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section.init(rawValue: indexPath.section) {
        case .tracks:
            viewModel.didSelectAudioTrack(at: indexPath.item)
        case .artists:
            viewModel.didSelectArtist(at: indexPath.item)
        case .playlists:
            viewModel.didSelectPlaylist(at: indexPath.item)
        case .episodes:
            viewModel.didSelectEpisode(at: indexPath.item)
        case .shows:
            viewModel.didSelectShow(at: indexPath.item)
        default:
            fatalError()
        }
    }
}

extension SearchViewController {
    
    static func create(viewModel: SearchViewModelProtocol) -> UIViewController {
        let viewController = SearchViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}

fileprivate enum Section: Int, CaseIterable {
    
    case tracks
    case artists
    case playlists
    case episodes
    case shows
    
    var cellTypeReuseIdentifier: String {
        return TableLargeCell.reuseIdentifier
    }
}
