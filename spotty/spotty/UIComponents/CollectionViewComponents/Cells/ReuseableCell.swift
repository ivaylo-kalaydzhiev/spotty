//
//  ReuseableCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 20.06.22.
//

import Foundation

protocol ReuseableCell {
    
    static var reuseIdentifier: String { get }
    func configure(with model: BusinessModel)
}
