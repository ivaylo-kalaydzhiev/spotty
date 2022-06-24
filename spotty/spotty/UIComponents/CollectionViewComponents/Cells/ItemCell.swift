//
//  ItemCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 22.06.22.
//

import UIKit

/// The cell used for Detail View of Artist, Playlist and Show. It displayes Items: AudioTrack or Episode
class ItemCell: UICollectionViewCell, ReuseableCell {
    
    static var reuseIdentifier = "ItemCell" // TODO: Make as extension to UICollectionView String(describing: self)
    
    let title = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        title.setCustomStyle(.mediumCellTitle)
        subtitle.setCustomStyle(.mediumCellSubtitle)
        imageView.setCustomStyle(.mediumCellImage)
        imageView.activate(anchors: [.height(70), .width(70)])
        
        // innerStackView
        let innerStackView = UIStackView(arrangedSubviews: [title, subtitle])
        innerStackView.axis = .vertical
        
        // outerStackView
        let outerStackView = UIStackView(arrangedSubviews: [imageView, innerStackView])
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.alignment = .center
        outerStackView.spacing = 10
        
        contentView.addSubview(outerStackView, anchors: [.leading(0), .trailing(0), .top(0)])
    }
    
    func configure(with model: BusinessModel) {
        if let track = model as? AudioTrack {
            title.text = track.name
            imageView.loadFrom(URLAddress: track.album.images[0].url)
        } else if let episode = model as? Episode {
            title.text = episode.name
            subtitle.text = episode.description
            imageView.loadFrom(URLAddress: episode.images[0].url)
        } else {
            fatalError("Business model unknown")
        }
    }
}

//TODO: DO THIS!!!
//
//import UIKit
//
//extension UITableViewCell {
//
//    static var reuseIdentifier: String {
//        String(describing: self)
//    }
//
//    var reuseIdentifier: String {
//        type(of: self).reuseIdentifier
//    }
//}
//
//extension UITableView {
//
//    func register<T: UITableViewCell>(_ type: T.Type) {
//        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
//    }
//
//    func reuse<T: UITableViewCell>(_ type: T.Type, _ indexPath: IndexPath) -> T {
//        dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
//    }
//}
