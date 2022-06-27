//
//  ItemCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 22.06.22.
//

import UIKit

/// The cell used for Detail View of Artist, Playlist and Show. It displayes Items: AudioTrack or Episode
class ItemCell: UITableViewCell, ReuseableCell {
    
    static var reuseIdentifier = "ItemCell"
    
    let title = UILabel()
    let subtitle = UILabel()
    let image = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        contentView.backgroundColor = .systemBackground
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        
        title.setCustomStyle(.mediumCellTitle)
        subtitle.setCustomStyle(.mediumCellSubtitle)
        image.setCustomStyle(.mediumCellImage)
        image.activate(anchors: [.height(70), .width(70)])
        
        // innerStackView
        let innerStackView = UIStackView(arrangedSubviews: [title, subtitle])
        innerStackView.axis = .vertical
        
        // outerStackView
        let outerStackView = UIStackView(arrangedSubviews: [image, innerStackView])
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.alignment = .center
        outerStackView.spacing = 10
        
        contentView.addSubview(outerStackView, anchors: [.leading(10), .trailing(-10), .top(10), .bottom(-10)])
    }
    
    func configure(with model: BusinessModel) {
        if let track = model as? AudioTrack {
            title.text = track.name
            image.loadFrom(URLAddress: track.album.images[0].url)
        } else if let episode = model as? Episode {
            title.text = episode.name
            subtitle.text = episode.description
            image.loadFrom(URLAddress: episode.images[0].url)
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
