//
//  ReuseableCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 20.06.22.
//

import Foundation

protocol SelfConfiguringCell {
    
    func configure(with model: BusinessModel)
}
