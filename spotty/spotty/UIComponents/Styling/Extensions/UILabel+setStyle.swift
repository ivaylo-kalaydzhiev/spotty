//
//  UILabel+setStyle.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 20.06.22.
//

import UIKit

extension UILabel {
    
    /// This function sets a custom UI Style for any `UILabel`
    ///  - Parameters:
    ///     - style: One of the styles represented by the `LabelStyle` enum
    func setCustomStyle(_ style: LabelStyle) {
        font = style.font
        textColor = style.textColor
        numberOfLines = style.numberOfLines
    }
}
