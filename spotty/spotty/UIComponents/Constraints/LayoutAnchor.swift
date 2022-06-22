//
//  LayoutAnchor.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 20.06.22.
//

import UIKit

/// Represents a single ``NSLayoutConstraint``
enum LayoutAnchor {
    
    case constant(attribute: NSLayoutConstraint.Attribute,
                  relation: NSLayoutConstraint.Relation,
                  constant: CGFloat)

    case relative(attribute: NSLayoutConstraint.Attribute,
                  relation: NSLayoutConstraint.Relation,
                  relatedTo: NSLayoutConstraint.Attribute,
                  multiplier: CGFloat,
                  constant: CGFloat)
}

// MARK: - Factory methods
extension LayoutAnchor {
    
    /// Premade anchor, relative to the leading constraint of the superview.
    static let leading = relative(attribute: .leading, relation: .equal, relatedTo: .leading)
    
    /// Premade anchor, relative to the trailing constraint of the superview.
    static let trailing = relative(attribute: .trailing, relation: .equal, relatedTo: .trailing)
    
    /// Premade anchor, relative to the top constraint of the superview.
    static let top = relative(attribute: .top, relation: .equal, relatedTo: .top)
    
    /// Premade anchor, relative to the bottom constraint of the superview.
    static let bottom = relative(attribute: .bottom, relation: .equal, relatedTo: .bottom)

    /// Premade anchor, relative to the X axis constraint of the superview.
    static let centerX = relative(attribute: .centerX, relation: .equal, relatedTo: .centerX)
    
    /// Premade anchor, relative to the X axis constraint of the superview.
    static let centerY = relative(attribute: .centerY, relation: .equal, relatedTo: .centerY)

    /// Premade anchor, lets you set a width contraint.
    static let width = constant(attribute: .width, relation: .equal)
    
    /// Premade anchor, lets you set a height contraint.
    static let height = constant(attribute: .height, relation: .equal)

    /// Method letting you create a constant anchor.
    /// - Parameters:
    ///   - attribute: The attribute you want to constraint.
    ///   - relation: The type of realtion you want to set.
    /// - Returns: Layout Anchor
    static func constant(
        attribute: NSLayoutConstraint.Attribute,
        relation: NSLayoutConstraint.Relation) -> (CGFloat) -> LayoutAnchor {
        return { constant in
            .constant(attribute: attribute,
                      relation: relation,
                      constant: constant)
        }
    }
    
    /// Method letting you create a relative anchor.
    /// - Parameters:
    ///   - attribute: The attribute you want to constraint.
    ///   - relation: The type of realtion you want to set.
    ///   - relatedTo: The attribute to which you want to relate the anchor.
    ///   - multiplier: Optionally set a multiplier.
    /// - Returns: Layout Anchor
    static func relative(
        attribute: NSLayoutConstraint.Attribute,
        relation: NSLayoutConstraint.Relation,
        relatedTo: NSLayoutConstraint.Attribute,
        multiplier: CGFloat = 1) -> (CGFloat) -> LayoutAnchor {
        return { constant in
            .relative(attribute: attribute,
                      relation: relation,
                      relatedTo: relatedTo,
                      multiplier: multiplier,
                      constant: constant)
        }
    }
}
