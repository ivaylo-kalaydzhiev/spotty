//
//  UIButton+setStyle.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit

extension UIButton {
    
    /// This function sets a custom UI Style for any `UIButton`
    ///  - Parameters:
    ///     - style: One of the styles represented by the `ButtonStyle` enum
    func setCustomStyle(_ style: ButtonStyle) {
        clipsToBounds = style.clipsToBounds
        layer.cornerRadius = style.cornerRadius
    }
}
