//
//  SectionHeader.swift
//  TryCollectionView
//
//  Created by Ivaylo Kalaydzhiev on 6.06.22.
//

import UIKit

protocol ReuseableHeader {
    
    static var reuseIdentifier: String { get }
}

class SectionHeader: UICollectionReusableView, ReuseableHeader {
    
    static let reuseIdentifier = "SectionHeader"
    
    let title = UILabel()
    let subtitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        styleAndSetupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func styleAndSetupUI() {
        let seperator = Seperator()
        title.setCustomStyle(.sectionHeaderTitle)
        subtitle.setCustomStyle(.sectionHeaderSubtitle)

        let stackView = UIStackView(arrangedSubviews: [seperator, title, subtitle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.setCustomSpacing(10, after: seperator)
        
        addSubview(stackView, anchors: [.leading(0), .trailing(0), .bottom(-10), .top(0)])
    }
}
