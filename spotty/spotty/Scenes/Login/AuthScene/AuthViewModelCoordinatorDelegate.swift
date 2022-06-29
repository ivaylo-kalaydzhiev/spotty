//
//  AuthViewModelCoordinatorDelegate.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 28.06.22.
//

import Foundation

protocol AuthViewModelCoordinatorDelegate: AnyObject {
    
    /// Navigate to ``AuthViewController``
    func didFinishAuthScene()
}
