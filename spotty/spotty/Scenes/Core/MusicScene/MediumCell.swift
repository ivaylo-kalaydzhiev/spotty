//
//  MediumCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 16.06.22.
//

import UIKit

class MediumCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseIdentifier = "MediumTableCell"
    
    let trackTitle = UILabel()
    let artistsLabel = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // name Style
        trackTitle.font = UIFont.preferredFont(forTextStyle: .headline)
        trackTitle.textColor = .label
        
        // subtitle Style
        artistsLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        artistsLabel.textColor = .secondaryLabel
        
        // imageView Style
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal) // This says: Don't stretch horizontaly!
        
        // innerStackView
        let innerStackView = UIStackView(arrangedSubviews: [trackTitle, artistsLabel])
        innerStackView.axis = .vertical
        
        // stackView Style
        let stackView = UIStackView(arrangedSubviews: [imageView, innerStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
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
        trackTitle.text = track.name
        artistsLabel.text = track.artists.map { $0.name }.joined(separator: ", ")
        imageView.loadFrom(URLAddress: track.album.images[2].url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
