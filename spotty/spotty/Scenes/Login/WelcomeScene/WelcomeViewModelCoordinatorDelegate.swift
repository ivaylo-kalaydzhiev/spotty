//
//  WelcomeViewModelCoordinatorDelegate.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 28.06.22.
//

import Foundation

protocol WelcomeViewModelCoordinatorDelegate: AnyObject {
    
    /// Navigate to ``AuthViewController``
    func didFinishWelcomeScene()
}
