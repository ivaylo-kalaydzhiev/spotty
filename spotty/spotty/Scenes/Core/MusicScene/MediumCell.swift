//
//  MediumCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 16.06.22.
//

import UIKit

class MediumCell: UICollectionViewCell {
    
    static var reuseIdentifier = "MediumCell"
    
    let title = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // title Style
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.textColor = .label
        
        // subtitle Style
        subtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitle.textColor = .secondaryLabel
        
        // imageView Style
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal) // This says: Don't stretch horizontaly!
        
        // innerStackView
        let innerStackView = UIStackView(arrangedSubviews: [title, subtitle])
        innerStackView.axis = .vertical
        
        // outerStackView
        let outerStackView = UIStackView(arrangedSubviews: [imageView, innerStackView])
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.alignment = .center
        outerStackView.spacing = 10
        contentView.addSubview(outerStackView)
        
        // Constraints
        // TODO: All UI Progrmatically. Add Constraints extension.
        NSLayoutConstraint.activate([
            outerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
