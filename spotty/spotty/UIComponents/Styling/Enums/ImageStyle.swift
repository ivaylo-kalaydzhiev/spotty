//
//  ImageStyle.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 20.06.22.
//

import UIKit

enum ImageStyle {
    
    case mediumCellImage
    case largeCellImage
    case circular
    
    var clipsToBounds: Bool { true }
    
    var cornerRadius: CGFloat {
        switch self {
        case .mediumCellImage, .largeCellImage:
            return 10
        case .circular:
            return 50
        }
    }
    
    var contentMode: UIView.ContentMode{
        switch self {
        case .largeCellImage:
            return .scaleAspectFill
        default:
            return .scaleToFill
        }
    }
}
