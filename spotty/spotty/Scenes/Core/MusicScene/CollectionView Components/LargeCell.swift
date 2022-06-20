//
//  LargeCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 17.06.22.
//

import UIKit

class LargeCell: UICollectionViewCell {
    
    static var reuseIdentifier = "LargeCell"
    
    let title = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title.setCustomStyle(.largeCellTitle)
        subtitle.setCustomStyle(.largeCellSubtitle)
        imageView.setCustomStyle(.largeCellImage)
        
        // Create, configure and add StackView
        let stackView = UIStackView(arrangedSubviews: [title, subtitle, imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.setCustomSpacing(10, after: subtitle)
        contentView.addSubview(stackView)
        
        // Constraints
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
