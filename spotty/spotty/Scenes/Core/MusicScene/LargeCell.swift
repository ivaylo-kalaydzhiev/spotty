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
        
        // seperator
        let seperator = UIView(frame: .zero)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = .quaternaryLabel
        
        // title Style
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        title.textColor = .label
        
        // subtitle Style
        subtitle.font = UIFont.preferredFont(forTextStyle: .title2)
        subtitle.textColor = .secondaryLabel
        
        // imageView Style
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        
        // Create, configure and add StackView
        let stackView = UIStackView(arrangedSubviews: [seperator, title, subtitle, imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        
        // Constraints
        NSLayoutConstraint.activate([
            seperator.heightAnchor.constraint(equalToConstant: 1),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        // Very cool and useful !!!
        stackView.setCustomSpacing(10, after: seperator)
        stackView.setCustomSpacing(10, after: subtitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
