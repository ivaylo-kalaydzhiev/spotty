//
//  CollectionViewStyle.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import UIKit

enum CollectionViewStyle {
    
    case main
    
    var autoresizingMask: UIView.AutoresizingMask {
        return [.flexibleWidth, .flexibleHeight]
    }
    
    var backgroundColor: UIColor? {
        return UIColor.background
    }
}
