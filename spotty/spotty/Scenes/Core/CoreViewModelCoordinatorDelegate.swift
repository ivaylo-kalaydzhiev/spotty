//
//  MusicViewModelCoordinatorDelegate.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 29.06.22.
//

import Foundation

protocol CoreViewModelCoordinatorDelegate: AnyObject {
    
    /// Navigate to ``DetailListViewController``
    func displayDetailListView(with model: BusinessModel)
    
    /// Navigate to ``DetailItemViewController``
    func displayDetailItemView(with model: BusinessModel)
}
