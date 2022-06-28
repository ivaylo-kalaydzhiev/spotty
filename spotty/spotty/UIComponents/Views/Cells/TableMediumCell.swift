//
//  TableMediumCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 22.06.22.
//

import UIKit

/// The cell used for Detail View of Artist, Playlist and Show. It displayes Items: AudioTrack or Episode
class TableMediumCell: UITableViewCell, SelfConfiguringCell {
    
    private let title = UILabel()
    private let subtitle = UILabel()
    private let image = UIImageView()
    
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
    
    private func setup() {
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
            image.loadFrom(URLAddress: track.album.imageURL)
        } else if let episode = model as? Episode {
            title.text = episode.name
            subtitle.text = episode.description
            image.loadFrom(URLAddress: episode.imageURL)
        } else {
            fatalError("Business model unknown")
        }
    }
}
