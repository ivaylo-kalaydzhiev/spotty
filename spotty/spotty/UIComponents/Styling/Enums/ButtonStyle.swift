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
    
    var cornerRadius: CGFloat {
        switch self {
        case .logIn: return 10
        }
    }
    
    var clipsToBounds: Bool {
        switch self {
        case .logIn: return true
        }
    }
}
