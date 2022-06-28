//
//  Seperator.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 20.06.22.
//

import UIKit

class Seperator: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .quaternaryLabel
        self.activate(anchors: [.height(1)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
