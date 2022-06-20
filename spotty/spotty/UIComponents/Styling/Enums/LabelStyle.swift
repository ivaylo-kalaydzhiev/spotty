//
//  LabelStyle.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 20.06.22.
//

import UIKit

enum LabelStyle {
    
    case sectionHeaderTitle
    case sectionHeaderSubtitle
    case mediumCellTitle
    case mediumCellSubtitle
    case largeCellTitle
    case largeCellSubtitle
    
    var font: UIFont? {
        switch self {
        case .sectionHeaderTitle:
            return UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 22, weight: .bold))
        case .sectionHeaderSubtitle:
            return nil
        case .mediumCellTitle:
            return .preferredFont(forTextStyle: .headline)
        case .mediumCellSubtitle:
            return .preferredFont(forTextStyle: .subheadline)
        case .largeCellTitle, .largeCellSubtitle:
            return .preferredFont(forTextStyle: .title2)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .sectionHeaderTitle, .mediumCellTitle, .largeCellTitle:
            return .label
        case .sectionHeaderSubtitle, .mediumCellSubtitle, .largeCellSubtitle:
            return .secondaryLabel
        }
    }
}
