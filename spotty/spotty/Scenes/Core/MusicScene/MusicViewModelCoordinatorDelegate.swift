//
//  MusicViewModelCoordinatorDelegate.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 29.06.22.
//

import Foundation

protocol MusicViewModelCoordinatorDelegate: AnyObject {
    
    /// Navigate to ``WelcomeViewController`` or ``TabBarViewController`` .
    func start()
}
