//
//  LargeCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 17.06.22.
//

import UIKit

class LargeCell: UICollectionViewCell, ReuseableCell {
    
    
    static var reuseIdentifier = "LargeCell"
    
    let title = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title.setCustomStyle(.largeCellTitle)
        subtitle.setCustomStyle(.largeCellSubtitle)
        imageView.setCustomStyle(.largeCellImage)
        
        let stackView = UIStackView(arrangedSubviews: [title, subtitle, imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.setCustomSpacing(10, after: subtitle)
        contentView.addSubview(stackView, anchors: [.leading(0), .trailing(0), .bottom(0), .top(0)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: BusinessModel) {
        if let playlist = model as? Playlist {
            imageView.loadFrom(URLAddress: playlist.images[0].url)
        } else {
            fatalError("Business model unknown")
        }
    }
}
