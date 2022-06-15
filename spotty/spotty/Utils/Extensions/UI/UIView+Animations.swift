//
//  UIView+Animations.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit

extension UIView {
    
    /// The UI View animates a spring bounce
    func bounce(duration: Double = 1,
                delay: Double = 0,
                springDamping: Double = 0.2,
                widthDiff: Double = 5,
                heightDiff: Double = 5) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: 0.0,
                       options: .allowUserInteraction,
                       animations: {
            
            let originalWidth = self.bounds.size.width
            let originalHeight = self.bounds.size.height
            
            self.bounds.size.width += widthDiff
            self.bounds.size.height += heightDiff
            
            self.bounds.size.width = originalWidth
            self.bounds.size.height = originalHeight
        })
    }
}
