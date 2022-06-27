//
//  ReuseableCell.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 20.06.22.
//

import Foundation

/// Cell that can configure itself purely based on the Data Model you pass to it.
protocol SelfConfiguringCell {
    
    /// The Cells UI is configured based on the information in the ``BusinessModel`` you provide.
    /// - Parameter model: The cell is configured based on the models properties.
    ///
    /// Keep in mind that not all Self Configuring Cells support all Business Models!
    func configure(with model: BusinessModel)
}
