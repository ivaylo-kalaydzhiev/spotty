//
//  UITableViewCell+reuseIdentifier.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 27.06.22.
//

import UIKit

extension UITableViewCell {

    static var reuseIdentifier: String {
        String(describing: self)
    }

    var reuseIdentifier: String {
        type(of: self).reuseIdentifier
    }
}
