//
//  ButtonStyle.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit

/// An Enum of custom `UIButton` styles to use troughout the app
enum ButtonStyle {
    
    case logIn
    case dismiss
    
    var cornerRadius: CGFloat {
        switch self {
        case .logIn: return 10
        default: return 0
        }
    }
    
    var clipsToBounds: Bool {
        switch self {
        case .logIn: return true
        default: return false
        }
    }
    
    var tintColor: UIColor? {
        switch self {
        case .dismiss: return .init(white: 1, alpha: 0.7)
        default: return nil
        }
    }
    
    var image: UIImage? {
        switch self {
        case .dismiss: return UIImage.System.xMarkCircle
        default: return nil
        }
    }
}
