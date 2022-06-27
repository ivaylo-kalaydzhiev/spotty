//
//  CollectionMediumCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 16.06.22.
//

import UIKit

class CollectionMediumCell: UICollectionViewCell, SelfConfiguringCell {
    
    private let title = UILabel()
    private let subtitle = UILabel()
    private let imageView = UIImageView()
    
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
    
    private func setup() {
        title.setCustomStyle(.mediumCellTitle)
        subtitle.setCustomStyle(.mediumCellSubtitle)
        imageView.setCustomStyle(.mediumCellImage)
        imageView.activate(anchors: [.height(65), .width(65)])
        
        let innerStackView = UIStackView(arrangedSubviews: [title, subtitle])
        innerStackView.axis = .vertical
        
        let outerStackView = UIStackView(arrangedSubviews: [imageView, innerStackView])
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.alignment = .center
        outerStackView.spacing = 10
        
        contentView.addSubview(outerStackView, anchors: [.leading(0), .trailing(0), .top(0)])
    }
    
    func configure(with model: BusinessModel) {
        if let track = model as? AudioTrack {
            title.text = track.name
            subtitle.text = track.artists.map { $0.name }.joined(separator: ", ")
            imageView.loadFrom(URLAddress: track.album.imageURL)
        } else if let artist = model as? Artist {
            title.text = artist.name
            subtitle.text = artist.genres?.joined(separator: ", ")
            imageView.image = UIImage.System.gear
        } else if let episode = model as? Episode {
            title.text = episode.name
            subtitle.text = episode.description
            imageView.loadFrom(URLAddress: episode.imageURL)
        } else {
            fatalError("Business model unknown")
        }
    }
}
