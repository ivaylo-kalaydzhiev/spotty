//
//  PlaylistCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 21.06.22.
//

import UIKit

class PlaylistCell: UITableViewCell, SelfConfiguringCell {
    
    let descriptionLabel = UILabel()
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
        
        descriptionLabel.setCustomStyle(.playlistDescription)
        image.setCustomStyle(.mediumCellImage)
        image.activate(anchors: [.height(90), .width(90)])
        
        // stackView
        let stackView = UIStackView(arrangedSubviews: [image, descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 10
        
        contentView.addSubview(stackView, anchors: [.leading(10), .trailing(-10), .top(10), .bottom(-10)])
    }
    
    func configure(with model: BusinessModel) {
        if let playlist = model as? Playlist {
            descriptionLabel.text = playlist.description
            image.loadFrom(URLAddress: playlist.images[0].url)
        } else {
            fatalError("Business model unknown")
        }
    }
}
