//
//  UIView+Constraints.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 20.06.22.
//

import UIKit

extension UIView {
    
    /// Add a Subview to a Superview and constrain it to it.
    /// - Parameters:
    ///   - subview: The Subview you want to add.
    ///   - anchors: Array of ``LayoutAnchor`` describing the relation between the Superview and the Subview.
    func addSubview(_ subview: UIView, anchors: [LayoutAnchor]) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        subview.activate(anchors: anchors, relativeTo: self)
    }
    
    /// Constraint a view to another item.
    /// - Parameters:
    ///   - anchors: Array of ``LayoutAnchor`` describing the relation between the view and the item.
    ///   - item: The item based on which you want to constraint the view.
    func activate(anchors: [LayoutAnchor], relativeTo item: UIView? = nil) {
        let constraints = anchors.map { NSLayoutConstraint(from: self, to: item, anchor: $0) }
        NSLayoutConstraint.activate(constraints)
    }
}
