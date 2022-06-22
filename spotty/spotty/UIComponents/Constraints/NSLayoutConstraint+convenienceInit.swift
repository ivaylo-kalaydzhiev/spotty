//
//  NSLayoutConstraint+convenienceInit.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 20.06.22.
//

import UIKit

extension NSLayoutConstraint {
    
    /// More easily create an ``NSLayoutConstraint``
    /// - Parameters:
    ///   - from: The View you want to constraint.
    ///   - item: The View to which tou want to constraint.
    ///   - anchor: ``LayoutAnchor`` describing the relation between the two Views.
    convenience init(from: UIView,
                     to item: UIView?,
                     anchor: LayoutAnchor) {
        
        switch anchor {
        case let .constant(attribute: attribute,
                           relation: relation,
                           constant: constant):
            self.init(
                item: from,
                attribute: attribute,
                relatedBy: relation,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: constant
            )
        case let .relative(attribute: attr,
                           relation: relation,
                           relatedTo: relatedTo,
                           multiplier: multiplier,
                           constant: constant):
            self.init(
                item: from,
                attribute: attr,
                relatedBy: relation,
                toItem: item,
                attribute: relatedTo,
                multiplier: multiplier,
                constant: constant
            )
        }
    }
}
