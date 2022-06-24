//
//  UICollectionView+setStyle.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import UIKit

extension UICollectionView {
    // TODO: add `` to all DocC
    /// This function sets a custom UI Style for any `UICollectionView`
    ///  - Parameters:
    ///     - style: One of the styles represented by the `ImageStyle` enum
    func setCustomStyle(style: CollectionViewStyle) {
        autoresizingMask = style.autoresizingMask
        backgroundColor = style.backgroundColor
    }
}
