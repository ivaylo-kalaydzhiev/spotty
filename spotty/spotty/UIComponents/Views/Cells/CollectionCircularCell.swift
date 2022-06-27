//
//  CollectionCircularCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 27.06.22.
//

import UIKit

class CollectionCircularCell: UICollectionViewCell, SelfConfiguringCell {
    
    private let imageView = UIImageView()
    private let title = UILabel()
    
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
        imageView.setCustomStyle(.circular)
        imageView.activate(anchors: [.width(100), .height(100)])
        title.setCustomStyle(.circularCell)
        title.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [imageView, title])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        
        contentView.addSubview(stackView, anchors: [.leading(5), .trailing(-5), .bottom(-5), .top(5)])
    }
    
    func configure(with model: BusinessModel) {
        if let artist = model as? Artist {
            title.text = artist.name
            imageView.loadFrom(URLAddress: artist.imageURL)
        } else {
            fatalError("Business model unknown")
        }
    }
}
