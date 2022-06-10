//
//  UIView+Animations.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit

extension UIView {
    
    /// The UI View animates a spring bounce
    func bounce() {
        UIView.animate(withDuration: 1,
                       delay: 0.0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 0.0,
                       options: .allowUserInteraction,
                       animations: {
            self.bounds.size.width += 5.0
            self.bounds.size.height += 5.0
        })
    }
}
