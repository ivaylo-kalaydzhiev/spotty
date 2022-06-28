//
//  CollectionLargeCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 17.06.22.
//

import UIKit

class CollectionLargeCell: UICollectionViewCell, SelfConfiguringCell {
    
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
        title.setCustomStyle(.largeCellTitle)
        subtitle.setCustomStyle(.largeCellSubtitle)
        imageView.setCustomStyle(.largeCellImage)
        
        let stackView = UIStackView(arrangedSubviews: [title, subtitle, imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.setCustomSpacing(10, after: subtitle)
        
        contentView.addSubview(stackView, anchors: [.leading(0), .trailing(0), .bottom(0), .top(0)])
    }
    
    func configure(with model: BusinessModel) {
        if let playlist = model as? Playlist {
            imageView.loadFrom(URLAddress: playlist.imageURL)
        } else if let show = model as? Show {
            imageView.loadFrom(URLAddress: show.imageURL)
        } else {
            fatalError("Business model unknown")
        }
    }
}
