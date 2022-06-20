//
//  MediumCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 16.06.22.
//

import UIKit

class MediumCell: UICollectionViewCell, ReuseableCell {
    
    static var reuseIdentifier = "MediumCell"
    
    let title = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title.setCustomStyle(.mediumCellTitle)
        subtitle.setCustomStyle(.mediumCellSubtitle)
        imageView.setCustomStyle(.mediumCellImage)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: BusinessModel) {
        if let track = model as? AudioTrack {
            title.text = track.name
            subtitle.text = track.artists.map { $0.name }.joined(separator: ", ")
            imageView.loadFrom(URLAddress: track.album.images[2].url)
        } else if let artist = model as? Artist {
            title.text = artist.name
            subtitle.text = artist.genres?.joined(separator: ", ")
            imageView.image = UIImage.init(systemName: "gear")
        } else {
            fatalError("Business model unknown")
        }
    }
}
