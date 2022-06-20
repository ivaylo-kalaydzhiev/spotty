//
//  SelfConfiguringCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 16.06.22.
//

import UIKit

protocol SelfConfiguringCell {
    
    associatedtype ItemType
    
    static var reuseIdentifier: String { get }
    func configure(with item: ItemType)
}
