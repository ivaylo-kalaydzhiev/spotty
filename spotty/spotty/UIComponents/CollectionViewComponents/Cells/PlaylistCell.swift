//
//  PlaylistCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 21.06.22.
//

import UIKit

class PlaylistCell: UICollectionViewCell, ReuseableCell {
    
    static var reuseIdentifier = "PlaylistCell" // TODO: Make as extension to UICollectionView String(describing: self)
    
    let descriptionLabel = UILabel()
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
        contentView.backgroundColor = UIColor.AppColor.foreground
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        
        descriptionLabel.setCustomStyle(.playlistDescription)
        imageView.setCustomStyle(.mediumCellImage)
        imageView.activate(anchors: [.height(90), .width(90)])
        
        // stackView
        let stackView = UIStackView(arrangedSubviews: [imageView, descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 10
        
        contentView.addSubview(stackView, anchors: [.leading(0), .trailing(0), .top(0), .bottom(0)])
    }
    
    func configure(with model: BusinessModel) {
        if let playlist = model as? Playlist {
            descriptionLabel.text = playlist.description
            imageView.loadFrom(URLAddress: playlist.images[0].url)
        } else {
            fatalError("Business model unknown")
        }
    }
}
