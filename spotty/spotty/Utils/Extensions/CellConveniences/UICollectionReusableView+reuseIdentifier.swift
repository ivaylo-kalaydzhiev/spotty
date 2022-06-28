//
//  UICollectionReusableView+reuseIdentifier.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 27.06.22.
//

import UIKit

extension UICollectionReusableView {

    static var identifier: String {
        String(describing: self)
    }

    var identifier: String {
        type(of: self).identifier
    }
}
