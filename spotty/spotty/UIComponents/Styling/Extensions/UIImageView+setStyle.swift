//
//  UIImageView+setStyle.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 20.06.22.
//

import Foundation
import UIKit

extension UIImageView {
    
    /// This function sets a custom UI Style for any `UIImageView`
    ///  - Parameters:
    ///     - style: One of the styles represented by the `ImageStyle` enum
    func setCustomStyle(_ style: ImageStyle) {
        clipsToBounds = style.clipsToBounds
        layer.cornerRadius = style.cornerRadius
        contentMode = style.contentMode
    }
}
