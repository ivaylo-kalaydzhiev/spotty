//
//  UICollectionViewCell+reuseIdentifier.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 27.06.22.
//

import UIKit

extension UICollectionViewCell {

    static var reuseIdentifier: String {
        String(describing: self)
    }

    open override var reuseIdentifier: String {
        type(of: self).reuseIdentifier
    }
}
