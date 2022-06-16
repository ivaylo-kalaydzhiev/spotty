//
//  MediumCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 16.06.22.
//

import UIKit

class MediumCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseIdentifier = "MediumTableCell"
    
    let name = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // name Style
        name.font = UIFont.preferredFont(forTextStyle: .headline)
        name.textColor = .label
        
        // imageView Style
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal) // This says: Don't stretch horizontaly!
        
        // stackView Style
        let stackView = UIStackView(arrangedSubviews: [imageView, name])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //stackView.alignment = .center
        stackView.spacing = 10
        stackView.axis = .horizontal
        contentView.addSubview(stackView)
        
        // Constraints
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    // Observable + ViewModel
    func configure(with track: AudioTrack) {
        name.text = track.name
        imageView.loadFrom(URLAddress: track.album.images[2].url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
