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
    case playlistDescription
    case detailViewTitle
    case detailItemTitle
    case circularCell
    
    var font: UIFont? {
        switch self {
        case .sectionHeaderTitle:
            return UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 22, weight: .bold))
        case .sectionHeaderSubtitle:
            return nil
        case .mediumCellTitle, .circularCell:
            return .preferredFont(forTextStyle: .headline)
        case .mediumCellSubtitle, .playlistDescription:
            return .preferredFont(forTextStyle: .subheadline)
        case .largeCellTitle, .largeCellSubtitle:
            return .preferredFont(forTextStyle: .title2)
        case .detailViewTitle, .detailItemTitle:
            return UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 35, weight: .bold))
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .sectionHeaderTitle,
             .mediumCellTitle,
             .largeCellTitle,
             .playlistDescription,
             .detailViewTitle,
             .detailItemTitle,
             .circularCell:
            return .label
        case .sectionHeaderSubtitle,
             .mediumCellSubtitle,
             .largeCellSubtitle:
            return .secondaryLabel
        }
    }
    
    var numberOfLines: Int {
        switch self {
        case .mediumCellSubtitle,
             .detailItemTitle,
             .circularCell:
            return 2
        case .playlistDescription:
            return 4
        default:
            return 1
        }
    }
    
    var adjustsFontSizeToFitWidth: Bool {
        switch self {
        case .detailItemTitle, .circularCell: return true
        default: return false
        }
    }
}
